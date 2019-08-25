class CreateMasterRestaurantGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :master_restaurant_genres do |t|
      t.string :parent_genre, null: false
      t.string :child_genres, null: false
      t.timestamps
    end
  end
end
