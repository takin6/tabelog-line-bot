class CreateMessageLineShareButtons < ActiveRecord::Migration[5.2]
  def change
    create_table :message_line_share_buttons do |t|
      t.belongs_to :restaurant_data_subset, foreign_key: true, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
