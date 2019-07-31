module Messenger
  module Line
    class UnfollowWrapper < BaseWrapper
      def post_initialize; end

      def receive
        user.is_blocked = true
        user.save!
      end

      def reply(_message); end
    end
  end
end
