class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :equipment_name
      t.string :model
      t.string :date
      t.string :engineer
      t.string :job_sheet_number
      t.string :supplier
      t.string :supplier_invoice_number
      t.string :supplier_Warranty_start
      t.string :supplier_Warranty_end
      t.string :customer_Warranty_start
      t.string :customer_Warranty_end
      t.references :specification, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
