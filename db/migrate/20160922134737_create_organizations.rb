class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.integer :users_count, default: 0
      t.string :intro
      t.string :detail_images, array: true, default: []
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :organizations, :sort
  end
end
