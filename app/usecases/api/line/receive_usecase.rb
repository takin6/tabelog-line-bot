module Api
  module Line
    class ReceiveUsecase
      attr_reader :user

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
        return ServiceResult.new(true) if event.is_a?(Line::Bot::Event::MessageType::Text) && event.message['text'] == "Hello, world" && Rails.env.development?

        @user = find_or_create_user(event["source"], client)

        event_wrapper = Line::EventFactory.new(user, event).create_event

        result = event_wrapper.validate
        if result.present?
          event_wrapper.reply_error_messages(result)
          return ServiceResult.new(true)
        end

        message = nil
        ActiveRecord::Base.transaction do
          message = event_wrapper.receive
          event_wrpper.reply(search_history)
        end

        return ServiceResult.new(true)
      end

      def find_or_create_user(source, client)
        profile_response = client.get_profile(source['userId'])
        profile = JSON.parse(profile_response.body)
        user = User.find_or_create_by(line_id: source['userId'], name: profile['displayName'], profile_picture_url: profile['pictureUrl'])
        return user
      end
    end
  end
end
