class ChatUnit < ApplicationRecord
  has_one :user, dependent: :destroy
  has_one :chat_room, dependent: :destroy
  has_one :chat_group, dependent: :destroy

  has_many :messages, dependent: :destroy

  enum chat_type: %i[user room group], _prefix: true

  def reply_to_entity(messages)
    case chat_type
    when "user"
      user.reply_to_user(messages)
    when "room"
      chat_room.reply_to_room(messages)
    when "group"
      chat_group.reply_to_group(messages)
    end
  end

  def initial_message_to_room?
    return false unless self.chat_type_room?
    
    self.messages.where(status: :reply).count == 0 ? true : false
  end


  def initial_message_to_group?
    return false unless self.chat_type_group?
    
    self.messages.where(status: :reply).count == 0 ? true : false
  end
end
