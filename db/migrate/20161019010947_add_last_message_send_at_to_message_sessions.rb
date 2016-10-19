class AddLastMessageSendAtToMessageSessions < ActiveRecord::Migration
  def change
    add_column :message_sessions, :last_message_send_at, :datetime
    add_index :message_sessions, :last_message_send_at
  end
end
