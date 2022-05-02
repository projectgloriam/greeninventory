class ChangeDistributorNameToDIstributors < ActiveRecord::Migration
  def up
    rename_column :distributors, :name, :distributor_name
  end

  def down
	rename_column :distributors, :distributor_name, :name
  end
end
