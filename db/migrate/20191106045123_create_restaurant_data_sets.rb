class CreateRestaurantDataSets < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurant_data_sets do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string :cache_id, null: false
      t.string :mongo_custom_restaurants_id, null: false
      t.json :selected_restaurant_ids, null: false
      t.timestamps
    end
  end
end
