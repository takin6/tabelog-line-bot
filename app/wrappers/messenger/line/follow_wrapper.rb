module Messenger
  module Line
    class FollowWrapper < BaseWrapper
      def post_initialize; end

      def receive
        chat_unit.is_blocking = false
        chat_unit.save!
      end

      def reply
        Messenger::ReplyFollowMessageWorker.perform_async(chat_unit.id)
      end
    end
  end
end
