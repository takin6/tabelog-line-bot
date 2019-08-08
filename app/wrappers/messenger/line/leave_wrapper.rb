module Messenger
  module Line
    class LeaveWrapper < BaseWrapper
      def post_initialize; end

      def receive
        chat_unit.is_blocking = true
        chat_unit.save!
      end

      def reply; end

      def leave_room
        client = Messenger::LineWrapper.new
        
        if chat_unit.chat_type_room?
          client.leave_room(chat_unit.chat_room.line_id)
        else
          client.leave_group(chat_unit.chat_group.line_id)
        end
      end
    end
  end
end