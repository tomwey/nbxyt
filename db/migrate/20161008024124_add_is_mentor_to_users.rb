class AddIsMentorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_mentor, :boolean, default: false
  end
end
