class ChangeColumnToMessagePostback < ActiveRecord::Migration[5.2]
  def change
    rename_column :message_postbacks, :mongo_custom_restaurants_id, :restaurant_data_subset_id
  end
end
