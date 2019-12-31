class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :omniauthable, :trackable
  belongs_to :chat_unit

  has_many :communities, class_name: "UserCommunity", dependent: :delete_all
  has_many :chat_rooms, through: :communities, source: :community, source_type: 'ChatRoom'
  has_many :chat_groups, through: :communities, source: :community, source_type: 'ChatGroup'

  has_many :search_histories, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :restaurant_data_sets, dependent: :destroy

  validates :line_id, presence: true
  validates :name, presence: true

  def messenger_wrapper
    return Messenger::LineWrapper.new
  end

  def reply_to_user(messages)
    result = messenger_wrapper.post_messages(self, messages)
    raise ArgumentError unless result.success
  end

  protected

  def password_required?
    return false
    super
  end

  def email_required?
    return false
    super
  end
end
