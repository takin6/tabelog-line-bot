class AddCacheIdToSearchHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :search_histories, :cache_id, :string, null: false
  end
end
