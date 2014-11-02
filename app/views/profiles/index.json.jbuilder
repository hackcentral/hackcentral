json.array!(@profiles) do |profile|
  json.extract! profile, :id, :name, :first_name, :last_name, :email, :school_grad, :bio, :website, :github, :dietary_needs, :resume
  json.url profile_url(profile, format: :json)
end
