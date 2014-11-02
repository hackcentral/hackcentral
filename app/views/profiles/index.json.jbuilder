json.array!(@profiles) do |profile|
  json.extract! profile, :id, :name, :first_name, :last_name, :email, :school_grad, :bio, :website, :github
  json.url profile_url(profile, format: :json)
end
