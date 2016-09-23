class RenameColumnForOrganizations < ActiveRecord::Migration
  def change
    rename_column :organizations, :users_count, :relationships_count
  end
end
