class Region < ApplicationRecord
  has_many :stations, dependent: :destroy
end
