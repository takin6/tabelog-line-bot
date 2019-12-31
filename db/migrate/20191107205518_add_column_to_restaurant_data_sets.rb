class AddColumnToRestaurantDataSets < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurant_data_sets, :title, :string, null: false, after: :selected_restaurant_ids 
  end
end
