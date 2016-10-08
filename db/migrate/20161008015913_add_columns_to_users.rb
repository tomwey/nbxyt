class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :realname, :string#,       null: false 会报错
    add_column :users, :stu_no, :string
    add_column :users, :faculty_id, :integer#,    null: false
    add_column :users, :specialty_id, :integer#,  null: false
    add_column :users, :graduation_id, :integer#, null: false
  end
end
