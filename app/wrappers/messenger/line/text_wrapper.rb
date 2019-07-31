module Messenger
  module Line
    class TextWrapper < BaseWrapper
      attr_reader :user, :text
      def post_initialize
        @text = event.message['text']
      end

      def validate
        # 始めのトライ
        if text == "Hello, world"
          message_params = [{　message_type: "text", user: user, message: "first try" }]
          return message_params
        end
      end

      def reply_error_messages(message_params)
        # どんなメッセージを送ってきたのかの履歴を見れる用
        ActiveRecord::Base.transaction do
          Message.create_receive_message!({ message_type: "text", user: user, message: text })
          message_params.each do |param|
            message = Message.create_reply_message!(param)
            user.reply_to_user([message])
          end
        end
      end

      def receive
        # ここはmessage_search_history的な感じにした方が良いのかなーーーー？
        received_message = Message.create_receive_message!({ message_type: "text", user: user, message: text  })

        return received_message
      end

      def reply(_message)
        Messenger::ReplyInstructionMessageWorker.perform_async user.id
      end
    end
  end
end
