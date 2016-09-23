class AddColumnToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :relationships_count, :integer, default: 0
  end
end
