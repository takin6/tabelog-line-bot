class AddAndRemoveColumsToSearchHistory < ActiveRecord::Migration[5.2]
  def change
    remove_column :search_histories, :meal_genre

    add_column :search_histories, :custom_meal_genres, :string, null: true, after: :meal_type
    add_column :search_histories, :template_meal_genres, :json, null: false, after: :meal_type
  end
end
