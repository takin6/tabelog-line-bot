class CreateRestaurantDataSubsets < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurant_data_subsets do |t|
      t.belongs_to :restaurant_data_set, foreign_key: true, null: false
      t.belongs_to :chat_unit, foreign_key: true, null: true

      t.json :selected_restaurant_ids, null: false
      t.integer :message_type, null: false

      t.timestamps
    end
  end
end
