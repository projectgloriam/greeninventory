json.array!(@products) do |product|
  json.extract! product, :id, :product_part_number, :product_description, :product_quantity, :product_price, :product_category_id, :OEM_partner_id
  json.url product_url(product, format: :json)
end
