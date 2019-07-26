class CreateLineLiffs < ActiveRecord::Migration[5.2]
  def change
    create_table :line_liffs do |t|
      t.string :liff_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
