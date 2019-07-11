class MessageText < ApplicationRecord
  belongs_to :message
  validates :value, presence: true
end