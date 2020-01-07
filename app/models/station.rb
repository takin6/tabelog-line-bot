class Station < ApplicationRecord
  include ::Searchable::Station

  belongs_to :area
  has_many :location_search_history, as: :location

  validates :name, presence: true
end
