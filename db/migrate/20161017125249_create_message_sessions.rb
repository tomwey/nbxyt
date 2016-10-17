class CreateMessageSessions < ActiveRecord::Migration
  def change
    create_table :message_sessions do |t|
      t.integer :sponsor_id, null: false, index: true
      t.integer :actor_id,   null: false, index: true
      t.integer :messages_count, default: 0

      t.timestamps null: false
    end
    add_index :message_sessions, [:sponsor_id, :actor_id], unique: true
  end
end
