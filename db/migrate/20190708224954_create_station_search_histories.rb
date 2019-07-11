class CreateStationSearchHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :station_search_histories do |t|
      t.belongs_to :station, null: false, foreign_key: true
      t.belongs_to :search_history, null: false, foreign_key: true
      t.timestamps
    end
  end
end
