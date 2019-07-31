module Messenger
  module Line
    class FollowWrapper < BaseWrapper
      def post_initialize; end

      def receive
        user.is_blocked = false
        user.save!
      end

      def reply(_message)
        Messenger::ReplyFollowMessageWorker.perform_async(user.id)
      end
    end
  end
end
