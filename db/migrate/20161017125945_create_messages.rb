class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content,       null: false
      t.string :msg_id,        null: false
      t.integer :sender_id,    null: false
      t.integer :recipient_id, null: false
      t.references :message_session, index: true, foreign_key: true
      t.boolean :unread, default: true

      t.timestamps null: false
    end
    add_index :messages, :sender_id
    add_index :messages, :recipient_id
    add_index :messages, :msg_id, unique: true
  end
end
