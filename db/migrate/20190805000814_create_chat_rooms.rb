class CreateChatRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_rooms do |t|
      t.belongs_to :chat_unit, null: false, foreign_key: true
      t.string :line_id, null: false

      t.timestamps
    end
  end
end

