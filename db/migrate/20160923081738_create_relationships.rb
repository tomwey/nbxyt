class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :relationshipable, polymorphic: true

      t.timestamps null: false
    end
    add_index :relationships, [:relationshipable_type, :relationshipable_id, :user_id], unique: true, name: 'index_relationships_on_relationshipable_and_user'
    add_index :relationships, [:relationshipable_type, :relationshipable_id], name: 'index_relationships_on_relationshipable'
  end
end
