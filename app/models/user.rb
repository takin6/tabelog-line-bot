class User < ApplicationRecord
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