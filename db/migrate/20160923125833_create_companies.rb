class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :mentor_id, index: true
      t.string :name,    null: false
      t.string :address, null: false
      t.string :intro
      t.string :link
      t.string :image,   null: false
      t.integer :sort, default: 0

      t.timestamps null: false
    end
  end
end
