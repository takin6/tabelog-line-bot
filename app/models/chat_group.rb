class ChatGroup < ApplicationRecord
  has_many :chat_units, as: :chat_community, dependent: :destroy
  validates :line_id, presence: true

  def messenger_wrapper
    return Messenger::LineWrapper.new
  end

  def reply_to_group(messages)
    result = messenger_wrapper.post_messages(self, messages)
    raise ArgumentError unless result.success
  end

  def self.create_or_find_all_entities!(group_line_id, user_params)
    chat_unit = nil

    ActiveRecord::Base.transaction do
      user = User.find_by(line_id: user_params[:line_id])

      unless user
        user = User.create!(
          line_id: user_params[:line_id],
          name: user_params[:name],
          profile_picture_url: user_params[:profile_picture_url]
        )
        chat_room = ChatGroup.create!(line_id: group_line_id)
        chat_unit = ChatUnit.create!(chat_type: :group, user: user, chat_community: chat_room)
      else
        chat_room = ChatGroup.find_by(line_id: group_line_id)
        if chat_room
          chat_unit = chat_room.chat_units.to_a.find {|chat_unit| chat_unit.user == user}
          unless chat_unit
            chat_unit = ChatUnit.create!(chat_type: :group, user: user, chat_community: chat_room)
          end
        else
          chat_room = ChatGroup.create!(line_id: group_line_id)
          chat_unit = ChatUnit.create!(chat_type: :group, user: user, chat_community: chat_room)
        end
      end
    end

    return chat_unit
  end
end
