class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.string :name, null: false
      t.string :profile_picture_url, null: true
      t.timestamps
    end
  end
end
