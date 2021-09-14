class AddGroupStringsToUsers < ActiveRecord::Migration
  def up
  	add_column "users", "group_strings", :string
  end

  def down
  	remove_column "users", "group_strings"
  end
end
