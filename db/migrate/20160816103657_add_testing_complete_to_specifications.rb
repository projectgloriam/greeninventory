class AddTestingCompleteToSpecifications < ActiveRecord::Migration
  def up
  	add_column :specifications, :tested, :boolean
  end

  def down
  	remove_column :specifications, :tested
  end
end
