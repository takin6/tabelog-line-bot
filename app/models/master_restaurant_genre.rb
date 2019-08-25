class MasterRestaurantGenre < ApplicationRecord
  validates :parent_genre, null: false
  validates :child_genres, null: false

  def to_h
    {
      id: id,
      parent_genre: parent_genre,
      child_genres: child_genres.split("、")
    }
  end
end
