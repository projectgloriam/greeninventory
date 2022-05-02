json.array!(@authorizers) do |authorizer|
  json.extract! authorizer, :id, :full_name, :department, :level
  json.url authorizer_url(authorizer, format: :json)
end
