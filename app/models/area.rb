class Area < ApplicationRecord
  include ::Searchable::Area

  belongs_to :region
  has_many :stations
  has_many :location_search_history, as: :location

  validates :name, presence: true
end
