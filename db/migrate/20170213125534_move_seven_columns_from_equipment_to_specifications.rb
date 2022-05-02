class MoveSevenColumnsFromEquipmentToSpecifications < ActiveRecord::Migration
  def up
  	add_column "specifications", "supplier", :string
    add_column "specifications", "supplier_invoice_number", :string
    add_column "specifications", "supplier_Warranty_start", :string
    add_column "specifications", "supplier_Warranty_end", :string
    add_column "specifications", "customer_Warranty_start", :string
    add_column "specifications", "customer_Warranty_end", :string
    add_column "specifications", "warranty_alert", :integer

  	remove_column "equipment", "supplier"
    remove_column "equipment", "supplier_invoice_number"
    remove_column "equipment", "supplier_Warranty_start"
    remove_column "equipment", "supplier_Warranty_end"
    remove_column "equipment", "customer_Warranty_start"
    remove_column "equipment", "customer_Warranty_end"
    remove_column "equipment", "warranty_alert"
  end

  def down
  	remove_column "specifications", "supplier"
    remove_column "specifications", "supplier_invoice_number"
    remove_column "specifications", "supplier_Warranty_start"
    remove_column "specifications", "supplier_Warranty_end"
    remove_column "specifications", "customer_Warranty_start"
    remove_column "specifications", "customer_Warranty_end"
    remove_column "specifications", "warranty_alert"

  	add_column "equipment", "supplier", :string
    add_column "equipment", "supplier_invoice_number", :string
    add_column "equipment", "supplier_Warranty_start", :string
    add_column "equipment", "supplier_Warranty_end", :string
    add_column "equipment", "customer_Warranty_start", :string
    add_column "equipment", "customer_Warranty_end", :string
    add_column "equipment", "warranty_alert", :integer
  end
end
