class AddUsernameToAuthorizers < ActiveRecord::Migration
  def up
  	add_column "authorizers", "username", :string
  end

  def down
  	remove_column "authorizers", "username"
  end
end
