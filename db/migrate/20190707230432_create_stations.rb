class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.belongs_to :area, null: true, foreign_key: true
      t.string :name, null: false, unique: true
      t.boolean :scraping_completed, null: false, default: false

      t.timestamps
    end
  end
end
