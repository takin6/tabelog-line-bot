class CreateMessageRestaurantDataSubsets < ActiveRecord::Migration[5.2]
  def change
    create_table :message_restaurant_data_subsets do |t|
      t.belongs_to :message, null: false, foreign_key: true
      t.string :restaurant_data_subset_id, null: false
      t.integer :page, default: 1

      t.timestamps
    end
  end
end
