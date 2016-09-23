class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name, null: false
      t.integer :mentors_count, default: 0
      t.integer :admin_id

      t.timestamps null: false
    end
    add_index :colleges, :admin_id
  end
end
