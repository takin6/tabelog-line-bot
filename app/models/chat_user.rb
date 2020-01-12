class ChatUser < ApplicationRecord
  has_many :chat_units, as: :chat_community, dependent: :destroy
  has_many :users, through: :chat_unit

  validates :line_id, presence: true

  def messenger_wrapper
    return Messenger::LineWrapper.new
  end

  def reply_to_user(messages)
    result = messenger_wrapper.post_messages(self, messages)
    raise ArgumentError unless result.success
  end

  def self.create_or_find_all_entities!(user_params)
    chat_user = nil

    ActiveRecord::Base.transaction do
      chat_user = ChatUser.find_by(line_id: user_params[:line_id])

      unless chat_user
        user = User.create!(
          line_id: user_params[:line_id],
          name: user_params[:name],
          profile_picture_url: user_params[:profile_picture_url]
        )

        chat_user = ChatUser.create!(
          line_id: user_params[:line_id],
        )
        chat_unit = ChatUnit.create!(chat_type: :user, user: user, chat_community: chat_user)
      end
    end

    return chat_user.chat_units[0]
  end
end
