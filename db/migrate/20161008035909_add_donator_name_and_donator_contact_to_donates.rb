class AddDonatorNameAndDonatorContactToDonates < ActiveRecord::Migration
  def change
    add_column :donates, :donator_name, :string
    add_column :donates, :donator_contact, :string
  end
end
