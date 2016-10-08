class CreateSpecialties < ActiveRecord::Migration
  def change
    create_table :specialties do |t|
      t.string :name
      t.integer :sort, default: 0

      t.timestamps null: false
    end
  end
end
