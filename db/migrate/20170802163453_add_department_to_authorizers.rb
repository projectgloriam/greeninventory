class AddDepartmentToAuthorizers < ActiveRecord::Migration
  def up
  	add_column "authorizers", "department", :string
  end

  def down
  	remove_column "authorizers", "department"
  end
end
