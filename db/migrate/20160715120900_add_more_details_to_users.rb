class AddMoreDetailsToUsers < ActiveRecord::Migration
  def up
  	add_column "users", "first_name", :string
  	add_column "users", "last_name", :string
  	add_column "users", "email", :string
  	add_column "users", "name", :string
  end

  def down
  	remove_column "users", "first_name"
  	remove_column "users", "last_name"
  	remove_column "users", "email"
  	remove_column "users", "name"
  end
end
