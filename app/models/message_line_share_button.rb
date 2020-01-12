class MessageLineShareButton < ApplicationRecord
  belongs_to :restaurant_data_subset

  validates :text, presence: true
end
