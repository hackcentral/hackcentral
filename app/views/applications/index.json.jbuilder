json.array!(@applications) do |application|
  json.extract! application, :id, :reimbursement_needed, :accepted, :profile_id, :user_id
  json.url application_url(application, format: :json)
end
