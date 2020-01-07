class CreateLocationSearchHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :location_search_histories do |t|
      t.belongs_to :search_history, foreign_key: true, index: true
      t.references :location, polymorphic: true, index: true

      t.timestamps
    end
  end
end
