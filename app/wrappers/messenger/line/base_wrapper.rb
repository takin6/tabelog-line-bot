module Messenger
  module Line
    class BaseWrapper
      attr_reader :chat_unit, :event
      def initialize(chat_unit, event)
        @chat_unit = chat_unit
        @event = event
        post_initialize
      end

      def post_initialize
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def validate
        return []
      end

      def receive
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def reply
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

    end
  end
end