class Message < ApplicationRecord
  belongs_to :user, optional: true

  delegate :value, to: :message_text, prefix: :message_text
  delegate :mongo_custom_restaurants_id, :page, to: :message_restaurant, prefix: :restaurant
  delegate :mongo_custom_restaurants_id, :page, to: :message_postback, prefix: :postback

  has_one :message_text, dependent: :destroy
  has_one :message_restaurant, dependent: :destroy
  has_one :message_postback, dependent: :destroy

  enum message_type: %i[text error_text restaurants postback]
  enum status: %i[reply receive]

  def self.create_receive_message!(params)
    message = self.create!(
      user: params[:user], 
      status: :receive, 
      message_type: params[:message_type]
    ).cast

    message.create_associates(params)

    return message
  end

  def self.create_reply_message!(params)
    message = self.create!(
      user: params[:user], 
      status: :reply, 
      message_type: params[:message_type]
    ).cast

    message.create_associates(params)

    return message
  end

  def cast
    self.becomes("Messages::#{message_type.camelcase}".constantize)
  end

  def create_associates(_params)
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end