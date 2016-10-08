class CreateDonateApplies < ActiveRecord::Migration
  def change
    create_table :donate_applies do |t|
      t.string :content, null: false
      t.string :contact, null: false

      t.timestamps null: false
    end
  end
end
