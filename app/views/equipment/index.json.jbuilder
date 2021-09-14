json.array!(@equipment) do |equipment|
  json.extract! equipment, :id, :equipment_name, :model, :date, :engineer, :job_sheet_number, :supplier, :supplier_invoice_number, :supplier_Warranty_start, :supplier_Warranty_end, :customer_Warranty_start, :customer_Warranty_end, :specification_id
  json.url equipment_url(equipment, format: :json)
end
