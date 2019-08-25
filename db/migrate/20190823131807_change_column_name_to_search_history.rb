class ChangeColumnNameToSearchHistory < ActiveRecord::Migration[5.2]
  def change
    rename_column :search_histories, :template_meal_genres, :master_genres
  end
end
