module Messenger
  module Line
    class UndefinedWrapper < BaseWrapper
      def post_initialize; end

      def receive
        Rails.logger.info "undefined event_type #{event}"
      end

      def reply; end
    end
  end
end
