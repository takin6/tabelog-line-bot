class CreateMessagePostbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :message_postbacks do |t|
      t.belongs_to :message, null: false, foreign_key: true
      t.integer :mongo_custom_restaurants_id, null: false
      t.integer :page, null: false

      t.timestamps
    end
  end
end
