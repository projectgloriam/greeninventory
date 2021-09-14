class AddWarrantyAlertToEquipment < ActiveRecord::Migration
	def up
		add_column "equipment", "warranty_alert", :integer
	end

	def down
		remove_column "equipment", "warranty_alert"
	end
end
