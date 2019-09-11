class ChatGroup < ApplicationRecord
  belongs_to :chat_unit

  has_many :user_communities, as: :community 
  has_many :users, through: :user_community

  validates :line_id, presence: true

  def messenger_wrapper
    return Messenger::LineWrapper.new
  end

  def reply_to_group(messages)
    result = messenger_wrapper.post_messages(self, messages)
    raise ArgumentError unless result.success
  end

  def self.create_or_find_all_entities!(group_line_id, user_params)
    chat_group = nil

    ActiveRecord::Base.transaction do
      chat_group = ChatGroup.find_by(line_id: group_line_id)
      unless chat_group
        chat_unit = ChatUnit.create!(chat_type: :group)
        chat_group = ChatGroup.create!(chat_unit: chat_unit, line_id: group_line_id)
      end

      user = User.find_by(line_id: user_params[:line_id])
      unless user
        chat_unit = ChatUnit.create!(chat_type: :group)
        user = User.create!(
          chat_unit: chat_unit, 
          line_id: user_params[:line_id],
          name: user_params[:name],
          profile_picture_url: user_params[:profile_picture_url]
        )
        UserCommunity.create!(community: chat_group, user: user)
      else
        UserCommunity.create!(community: chat_group, user: user) if user.chat_groups.include?(chat_group)
      end
    end

    return chat_group.chat_unit
  end
end
