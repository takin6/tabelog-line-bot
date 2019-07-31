class AddIsblockedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_blocked, :boolean, :after => :profile_picture_url, null: false, default: false
  end
end
