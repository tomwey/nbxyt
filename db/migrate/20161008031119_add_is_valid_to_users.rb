class AddIsValidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_valid, :boolean, default: false
  end
end
