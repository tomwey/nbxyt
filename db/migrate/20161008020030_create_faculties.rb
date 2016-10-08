class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name, null: false
      t.integer :sort, default: 0

      t.timestamps null: false
    end
  end
end
