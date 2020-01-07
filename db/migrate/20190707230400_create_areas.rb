class CreateAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :areas do |t|
      t.belongs_to :region, null: false, foreign_key: true
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
