class CreateUserCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :user_communities do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.references :community, polymorphic: true, index: true, null: false
      t.timestamps
    end
  end
end
