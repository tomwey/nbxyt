class ChangeColumnsForOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :founded_on, :date#, null: false
    add_column :organizations, :image, :string#, null: false
    add_column :organizations, :body, :text#, null: false
    remove_column :organizations, :detail_images
    
  end
end
