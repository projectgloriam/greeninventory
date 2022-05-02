json.array!(@leaves) do |leafe|
  json.extract! leafe, :id, :staff_name, :department, :commencement_date, :days_applied_for, :vacation_address, :authorizer, :final_authorizer
  json.url leafe_url(leafe, format: :json)
end
