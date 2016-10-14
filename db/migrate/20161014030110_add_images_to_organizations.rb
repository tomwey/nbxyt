class AddImagesToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :images, :string, array: true, default: []
  end
end
