module Api
  module Line
    class ReceiveUsecase
      attr_reader :chat_unit

      def receive(request)
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        body = request.body.read
        client = ::Messenger::LineWrapper.new
        return ServiceResult.new(false, "validation signature failed") unless client.validate_signature(body, signature)

        execute(body, client)
      end

      private

      def execute(body, client)
        event = client.parse_events_from(body)[0]
        Rails.logger.info "#{event}"
        return handle_block_event(event["source"]) if is_block_event?(event)

        @chat_unit = find_or_create_chat_unit(event["source"], client)

        return ServiceResult.new(true) unless chat_unit
        event_wrapper = ::Line::EventFactory.new(chat_unit, event).create_event

        # テキスト廃止する・・？？どうしよっかなー
        result = event_wrapper.validate
        if result.present?
          event_wrapper.reply_error_messages(result)
          return ServiceResult.new(true)
        end

        ActiveRecord::Base.transaction do
          event_wrapper.receive
        end
        event_wrapper.reply

        return ServiceResult.new(true)
      end

      private

      def find_or_create_chat_unit(source, client)
        case source["type"]
        when "user"
          find_or_create_user(source["userId"], client)
        when "room"
          find_or_create_room(source["userId"], source["roomId"], client)
        when "group"
          find_or_create_group(source["userId"], source["groupId"], client)
        end
      end

      def find_or_create_user(line_id, client)
        profile_response = client.get_profile(line_id)
        # for webhook first try
        return nil if profile_response&.message == "Not Found"
        profile = JSON.parse(profile_response.body)

        chat_unit = ChatUser.create_or_find_all_entities!(line_id: line_id, name: profile['displayName'], profile_picture_url: profile['pictureUrl'] )

        return chat_unit
      end

      def find_or_create_room(user_line_id, room_line_id, client)
        user_profile_response = client.get_room_member_profile(room_line_id, user_line_id)
        return nil if user_profile_response&.message == "Not Found"
        profile = JSON.parse(user_profile_response.body)

        chat_unit = ChatRoom.create_or_find_all_entities!(room_line_id, {
          line_id: profile["userId"], name: profile['displayName'], profile_picture_url: profile['pictureUrl']
        })

        return chat_unit
      end

      def find_or_create_group(user_line_id, group_line_id, client)
        user_profile_response = client.get_group_member_profile(group_line_id, user_line_id)
        return nil if user_profile_response&.message == "Not Found"
        profile = JSON.parse(user_profile_response.body)

        chat_unit = ChatGroup.create_or_find_all_entities!(group_line_id, {
          line_id: profile["userId"], name: profile['displayName'], profile_picture_url: profile['pictureUrl']
        })

        return chat_unit
      end

      def handle_block_event(source)
        # ここも修正必要
        user = User.find_by(line_id: source['userId'])
        user.is_blocked = true
        user.save!

        return ServiceResult.new(true)
      end

      def is_block_event?(event)
        return true if event.is_a?(::Line::Bot::Event::Unfollow)
      end
    end
  end
end
