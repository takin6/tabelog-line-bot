class CreateChatUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_units do |t|
      t.integer :chat_type, null: false
      t.boolean :is_blocking, null: false, default: false

      t.timestamps
    end
  end
end
