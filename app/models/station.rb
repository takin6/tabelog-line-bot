class Station < ApplicationRecord
  include ::Searchable::Station

  belongs_to :area, optional: true
  has_many :location_search_history, as: :location

  validates :name, presence: true
end
