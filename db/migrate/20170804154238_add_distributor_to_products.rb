class AddDistributorToProducts < ActiveRecord::Migration
  def up
    add_reference :products, :distributor, index: true, foreign_key: true
  end

  def down
	remove_reference :products, :distributor, index: true, foreign_key: true
  end
end
