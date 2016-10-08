class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
