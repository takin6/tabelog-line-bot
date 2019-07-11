class Station < ApplicationRecord
  belongs_to :region
  has_many :search_histories, through: :station_search_histories

  validates :name, presence: true
end
