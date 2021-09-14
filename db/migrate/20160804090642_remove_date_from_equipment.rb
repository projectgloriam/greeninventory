class RemoveDateFromEquipment < ActiveRecord::Migration
  def up
  	remove_column "equipment", "date"
  end

  def down
  	add_column "equipment", "date", :string
  end
end
