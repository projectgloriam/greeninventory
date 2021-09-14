json.array!(@serials) do |serial|
  json.extract! serial, :id, :serial_number, :equipment_id
  json.url serial_url(serial, format: :json)
end
