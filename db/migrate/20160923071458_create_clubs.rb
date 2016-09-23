class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name,  null: false
      t.string :title, null: false
      t.text :body,    null: false
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :clubs, :sort
  end
end
