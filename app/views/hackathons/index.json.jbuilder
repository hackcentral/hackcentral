json.array!(@hackathons) do |hackathon|
  json.extract! hackathon, :id, :name, :about, :tagline, :location, :slug
  json.url hackathon_url(hackathon, format: :json)
end
