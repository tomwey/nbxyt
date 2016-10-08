class CreateDonates < ActiveRecord::Migration
  def change
    create_table :donates do |t|
      t.string :title, null: false
      t.string :intro
      t.text :body,    null: false
      t.string :image
      t.date :donated_on, null: false

      t.timestamps null: false
    end
  end
end
