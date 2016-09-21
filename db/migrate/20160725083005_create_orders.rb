class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_no, null: false
      t.references :product, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :note
      t.integer :quantity, default: 1
      t.integer :total_fee, default: 0
      t.string :state, default: 'pending'
      t.integer :shipment_id

      t.timestamps null: false
    end
    add_index :orders, :order_no, unique: true
    add_index :orders, :shipment_id
  end
end
