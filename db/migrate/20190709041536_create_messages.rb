class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.belongs_to :chat_unit, null: false, foreign_key: true
      t.integer :message_type, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
