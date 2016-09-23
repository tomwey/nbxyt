class RenameColumnForEvents < ActiveRecord::Migration
  def change
    rename_column :events, :attend_count, :attends_count
  end
end
