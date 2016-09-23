class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
      t.references :college, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true, unique: true
      t.string :name, null: false
      t.boolean :verified, default: false

      t.timestamps null: false
    end
  end
end
