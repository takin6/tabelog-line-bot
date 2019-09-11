class AllowNilToMasterGenres < ActiveRecord::Migration[5.2]
  def change
    change_column :search_histories, :master_genres, :json, null: true, after: :meal_type
  end
end
