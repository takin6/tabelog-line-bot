class ChangeColumnToNullTrue < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :profile_picture_url, :string, null: true
  end
end
