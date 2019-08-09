class MigrateToMonetize < ActiveRecord::Migration[5.2]
  def change
    remove_column :search_histories, :lower_budget
    remove_column :search_histories, :upper_budget

    add_monetize :search_histories, :lower_budget, null: true
    add_monetize :search_histories, :upper_budget, null: true
  end
end
