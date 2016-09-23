class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :sender, null: false
      t.integer :receiver
      t.string :content, null: false
      t.references :replyable, index: true, polymorphic: true

      t.timestamps null: false
    end
    add_index :replies, :sender
    add_index :replies, :receiver
  end
end
