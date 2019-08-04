class AddColumnToStation < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :scraping_completed, :boolean, after: :name, null: false, default: false
  end
end
