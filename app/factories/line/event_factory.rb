module Line
  class EventFactory
    attr_reader :user, :event

    def initialize(user, event)
      @user = user
      @event = event
    end

    def create_event
      case event
      when ::Line::Bot::Event::Follow
        return Messenger::Line::FollowWrapper.new(user, event)
      when ::Line::Bot::Event::UnFollow
        return Messenger::Line::UnFollowWrapper.new(user, event)
      when ::Line::Bot::Event::Message
        case event.type
        when ::Line::Bot::Event::MessageType::Text
          return Messenger::Line::TextWrapper.new(user, event)
        else
          # 「フォーマットに従ってください」メッセージをリターンする
          return ServiceResult.new(false, "message type not text")
        end
      when ::Line::Bot::Event::Postback
        return Messenger::Line::PostbackWrapper.new(user, event)
      else
        return ServiceResult.new(false, "event type not existed")
      end

    end

  end
end