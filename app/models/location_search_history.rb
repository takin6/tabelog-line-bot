class LocationSearchHistory < ApplicationRecord
  belongs_to :search_history
  belongs_to :location, polymorphic: true
end
