module Messenger
  module Line
    class TextWrapper < BaseWrapper
      attr_reader :chat_unit, :text
      def post_initialize
        @text = event.message['text']
      end

      def validate
        # 始めのトライ
        if text == "Hello, world"
          message_params = [{　message_type: "text", chat_unit: chat_unit, message: "first try" }]
          return message_params
        end
      end

      def reply_error_messages(message_params)
        # どんなメッセージを送ってきたのかの履歴を見れる用
        ActiveRecord::Base.transaction do
          Message.create_receive_message!({ message_type: "text", chat_unit: chat_unit, message: text })
          message_params.each do |param|
            message = Message.create_reply_message!(param)
            chat_unit.reply_to_entity([message])
          end
        end
      end

      def receive
        # ここはmessage_search_history的な感じにした方が良いのかなーーーー？
        received_message = Message.create_receive_message!({ message_type: "text", chat_unit: chat_unit, message: text  })

        return received_message
      end

      def reply
        Messenger::ReplyInstructionMessageWorker.perform_async chat_unit.id if user_wants_instruction?
        
        LeaveWrapper.new(chat_unit, event).leave_room if user_wants_to_dismember? && (chat_unit.chat_type_room? || chat_unit.chat_type_group?)
      end

      private

      def user_wants_instruction?
        return true if ["マニュアル", "ティラミス", "フォーム", "検索フォーム"].include?(text)
      end

      def user_wants_to_dismember?
        return true if ["ティラミス bye"].include?(text)
      end
    end
  end
end
