json.array!(@oem_partners) do |oem_partner|
  json.extract! oem_partner, :id, :OEM_name, :OEM_logo
  json.url oem_partner_url(oem_partner, format: :json)
end
