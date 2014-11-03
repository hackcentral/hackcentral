json.array!(@applications) do |application|
  json.extract! application, :id, :reimbursement_needed, :accepted
  json.url application_url(application, format: :json)
end
