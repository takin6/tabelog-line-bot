class RemoveForeignKeyFromRestaurantDataSubset < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :restaurant_data_subsets, :restaurant_data_sets
  end
end
