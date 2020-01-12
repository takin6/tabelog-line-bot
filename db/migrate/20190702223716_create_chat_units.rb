class CreateChatUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_units do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :chat_type, null: false
      t.references :chat_community, polymorphic: true, index: true 
      t.boolean :is_blocking, null: false, default: false

      t.timestamps
    end
  end
end
