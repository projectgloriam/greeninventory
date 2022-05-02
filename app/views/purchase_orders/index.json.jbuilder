json.array!(@purchase_orders) do |purchase_order|
  json.extract! purchase_order, :id, :purchase_order_title, :client_id
  json.url purchase_order_url(purchase_order, format: :json)
end
