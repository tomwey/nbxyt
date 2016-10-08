class CreatePracticeBases < ActiveRecord::Migration
  def change
    create_table :practice_bases do |t|
      t.string :name,    null: false
      t.string :address, null: false
      t.string :intro,   null: false
      t.string :body,    null: false
      t.string :image,   null: false
      t.references :user, index: true, foreign_key: true
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :practice_bases, :sort
  end
end
