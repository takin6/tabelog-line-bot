class Station < ApplicationRecord
  include ::Searchable::Station

  belongs_to :region
  has_many :search_histories, through: :station_search_histories

  validates :name, presence: true
end
