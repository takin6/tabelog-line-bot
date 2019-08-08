module Line
  class EventFactory
    attr_reader :chat_unit, :event

    def initialize(chat_unit, event)
      @chat_unit = chat_unit
      @event = event
    end

    def create_event
      case event
      when ::Line::Bot::Event::Follow
        return Messenger::Line::FollowWrapper.new(chat_unit, event)
      when ::Line::Bot::Event::Message
        case event.type
        when ::Line::Bot::Event::MessageType::Text
          return Messenger::Line::TextWrapper.new(chat_unit, event)
        else
          # 「フォーマットに従ってください」メッセージをリターンする
          return ServiceResult.new(false, "message type not text")
        end
      when ::Line::Bot::Event::Postback
        return Messenger::Line::PostbackWrapper.new(chat_unit, event)
      when ::Line::Bot::Event::Join
        return Messenger::Line::JoinWrapper.new(chat_unit, event)
      when ::Line::Bot::Event::Leave
        return Messenger::Line::LeaveWrapper.new(chat_unit, event)
      else
        # joinイベントは、userがメッセージを送信して初めて呼び出されるため、処理しない
        return Messenger::Line::UndefinedWrapper.new(chat_unit, event)
      end

    end

  end
end