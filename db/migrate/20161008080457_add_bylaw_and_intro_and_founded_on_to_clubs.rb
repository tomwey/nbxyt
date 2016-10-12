class AddBylawAndIntroAndFoundedOnToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :bylaw, :text#,      null: false
    add_column :clubs, :intro, :string
    add_column :clubs, :image, :string#,    null: false
    add_column :clubs, :founded_on, :date#, null: false

  end
end
