class ChatRoom < ApplicationRecord
  belongs_to :chat_unit

  has_many :user_communities, as: :community, dependent: :destroy
  has_many :users, through: :user_communities

  validates :line_id, presence: true

  def messenger_wrapper
    return Messenger::LineWrapper.new
  end

  def reply_to_room(messages)
    result = messenger_wrapper.post_messages(self, messages)
    raise ArgumentError unless result.success
  end

  def self.create_or_find_all_entities!(room_line_id, user_params)
    chat_room = nil

    ActiveRecord::Base.transaction do
      chat_room = ChatRoom.find_by(line_id: room_line_id)
      unless chat_room
        chat_unit = ChatUnit.create!(chat_type: :room)
        chat_room = ChatRoom.create!(chat_unit: chat_unit, line_id: room_line_id)
      end

      user = User.find_by(line_id: user_params[:line_id])
      unless user
        chat_unit = ChatUnit.create!(chat_type: :room)
        user = User.create!(
          chat_unit: chat_unit, 
          line_id: user_params[:line_id],
          name: user_params[:name],
          profile_picture_url: user_params[:profile_picture_url]
        )
        ChatCommunity.create!(community: chat_room, user: user)
      else
        ChatCommunity.create!(community: chat_room, user: user) if user.chat_rooms.include?(chat_room)
      end
    end

    return chat_room.chat_unit
  end
end
