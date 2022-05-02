json.array!(@distributors) do |distributor|
  json.extract! distributor, :id, :name, :currency, :fairgreen_price_formula
  json.url distributor_url(distributor, format: :json)
end
