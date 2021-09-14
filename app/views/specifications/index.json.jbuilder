json.array!(@specifications) do |specification|
  json.extract! specification, :id, :case, :title, :client, :contact_person, :email, :telephone, :comment
  json.url specification_url(specification, format: :json)
end
