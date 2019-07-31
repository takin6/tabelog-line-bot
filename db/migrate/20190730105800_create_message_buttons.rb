class CreateMessageButtons < ActiveRecord::Migration[5.2]
  def change
    create_table :message_buttons do |t|
      t.belongs_to :message, null: false, foreign_key: true
      t.json :actions, null: false
      t.string :text, null: false
      t.string :thumbnail_image_url, null: false

      t.timestamps
    end
  end
end
