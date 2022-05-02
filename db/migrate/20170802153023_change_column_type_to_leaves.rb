class ChangeColumnTypeToLeaves < ActiveRecord::Migration
  def up
  	change_column :leaves, :authorizer, :string, :default => ''
  	change_column :leaves, :final_authorizer, :string, :default => ''
  end

  def down
  	change_column :leaves, :authorizer, :integer
  	change_column :leaves, :final_authorizer, :integer
  end
end