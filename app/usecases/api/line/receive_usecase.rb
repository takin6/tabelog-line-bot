module Api
  module Line
    class ReceiveUsecase
      attr_reader :chat_unit

      def receive(request)
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        body = request.body.read
        client = Messenger::LineWrapper.new
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
          find_or_create_room(source["roomId"], client)
        when "group"
          find_or_create_group(source["groupId"], client)
        end
      end

      def find_or_create_user(line_id, client)
        profile_response = client.get_profile(line_id)
        # for webhook first try
        return nil if profile_response&.message == "Not Found"
        profile = JSON.parse(profile_response.body)

        chat_unit = nil

        ActiveRecord::Base.transaction do
          user = User.find_by(line_id: line_id, name: profile['displayName'], profile_picture_url: profile['pictureUrl'])

          unless user
            chat_unit = ChatUnit.create!(chat_type: :user)
            user = User.create!(chat_unit: chat_unit, line_id: line_id, name: profile['displayName'], profile_picture_url: profile['pictureUrl'])
          end

          chat_unit = user.chat_unit
        end

        return chat_unit
      end

      def find_or_create_room(room_id, client)
        chat_unit = nil
        # プレミアムアカウントでしか、get_room_member_idsできないらしい。。
        ActiveRecord::Base.transaction do
          chat_room = ChatRoom.find_by(line_id: room_id)

          unless chat_room
            chat_unit = ChatUnit.create!(chat_type: :room)
            chat_room = ChatRoom.create!(chat_unit_id: chat_unit.id, line_id: room_id)
          end

          chat_unit = chat_room.chat_unit
        end

        return chat_unit
      end

      def find_or_create_group(group_id, client)
        chat_unit = nil
        # プレミアムアカウントでしか、get_group_member_idsできないらしい。。
        ActiveRecord::Base.transaction do
          chat_group = ChatGroup.find_by(line_id: group_id)

          unless chat_group
            chat_unit = ChatUnit.create!(chat_type: :group)
            chat_group = ChatGroup.create!(chat_unit_id: chat_unit.id, line_id: group_id)
          end

          chat_unit = chat_group.chat_unit
        end

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
