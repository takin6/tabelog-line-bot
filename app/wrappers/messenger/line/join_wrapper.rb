module Messenger
  module Line
    class JoinWrapper < BaseWrapper
      def post_initialize; end

      def receive
        chat_unit.is_blocking = false
        chat_unit.save!
      end

      def reply
        # roomの時は、messageが送られて来て初めてjoin eventが発行されるため
        Messenger::ReplyInstructionMessageWorker.perform_async(chat_unit.id, true) if chat_unit.chat_type_group?
      end
    end
  end
end