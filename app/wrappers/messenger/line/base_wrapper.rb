module Messenger
  module Line
    class BaseWrapper
      attr_reader :user, :event
      def initialize(user, event)
        @user = user
        @event = event
        post_initalize
      end

      def post_initalize; end

    end
  end
end