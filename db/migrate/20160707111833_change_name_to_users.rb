class ChangeNameToUsers < ActiveRecord::Migration
  def up
  	rename_column "users", "name", "login"
  end

  def down
  	rename_column "users", "login", "name"
  end
end
