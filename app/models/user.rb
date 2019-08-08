class User < ApplicationRecord
  belongs_to :chat_unit

  has_many :communities, class_name: "UserCommunity", dependent: :delete_all
  has_many :chat_rooms, through: :communities, source: :community, source_type: 'ChatRoom'
  has_many :chat_groups, through: :communities, source: :community, source_type: 'ChatGroup'

  has_many :search_histories, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :line_id, presence: true
  validates :name, presence: true

  def messenger_wrapper
    return Messenger::LineWrapper.new
  end

  def reply_to_user(messages)
    result = messenger_wrapper.post_messages(self, messages)
    raise ArgumentError unless result.success
  end
end
