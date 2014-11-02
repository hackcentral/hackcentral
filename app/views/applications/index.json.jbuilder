json.array!(@applications) do |application|
  json.extract! application, :id, :name, :first_name, :last_name, :email, :school_grad, :bio
  json.url application_url(application, format: :json)
end
