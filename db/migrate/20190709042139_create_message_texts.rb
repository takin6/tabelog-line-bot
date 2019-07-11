class CreateMessageTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :message_texts do |t|
      t.belongs_to :message, null: false, foreign_key: true
      t.text :value, null: false

      t.timestamps
    end
  end
end
