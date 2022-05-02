class ChangeOemPartnersIndexToProducts < ActiveRecord::Migration
  def up
	remove_reference :products, :OEM_partner, index: true, foreign_key: true
    add_reference :products, :oem_partner, index: true, foreign_key: true
  end

  def down
	remove_reference :products, :oem_partner, index: true, foreign_key: true
    add_reference :products, :OEM_partner, index: true, foreign_key: true
  end
end
