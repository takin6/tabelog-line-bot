class LineLiff < ApplicationRecord
  validates :name, presence: true
  validates :liff_id, presence: true
end
