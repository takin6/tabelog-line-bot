class CreateSearchHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :search_histories do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.integer :lower_budget, null: false, default: 0
      t.integer :upper_budget, null: false, default: 0
      t.integer :meal_type, null: false, default: 1
      t.string :meal_genre, null: true
      t.string :situation, null: true
      t.string :other_requests, null: true
      t.boolean :completed, null: false, default: false
      t.timestamps
    end
  end
end