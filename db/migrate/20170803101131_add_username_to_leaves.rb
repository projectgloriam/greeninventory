class AddUsernameToLeaves < ActiveRecord::Migration
  def up
  	add_column "leaves", "username", :string
  end

  def down
  	remove_column "leaves", "username"
  end
end