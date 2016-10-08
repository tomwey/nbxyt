class AddFacultyIdToSpecialties < ActiveRecord::Migration
  def change
    add_column :specialties, :faculty_id, :integer
    add_index :specialties, :faculty_id
  end
end
