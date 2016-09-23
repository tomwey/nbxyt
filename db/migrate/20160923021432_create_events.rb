class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :body,    null: false
      t.string :image
      t.integer :attend_count,  default: 0
      t.integer :total_attends, default: 0
      t.datetime :started_at, null: false
      t.datetime :ended_at,   null: false
      t.references :eventable, polymorphic: true, index: true
      t.integer :sort, default: 0
      t.boolean :visible, default: true

      t.timestamps null: false
    end
  end
end
