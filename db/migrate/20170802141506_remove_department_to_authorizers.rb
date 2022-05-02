class RemoveDepartmentToAuthorizers < ActiveRecord::Migration
  def up
  	remove_column "authorizers", "department"
  end

  def down
  	add_column "authorizers", "department", :string
  end
end
