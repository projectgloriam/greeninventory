class AddTechnicianReportToEquipment < ActiveRecord::Migration
  def up
  	add_column :equipment, :technician_report, :string
  end

  def down
  	remove_column :equipment, :technician_report
  end
end
