class ChangeColumnsForCompanies < ActiveRecord::Migration
  def change
    rename_column :companies, :mentor_id, :user_id
    add_column :companies, :body, :text, null: false
  end
end
