json.array!(@hackathons) do |hackathon|
  json.extract! hackathon, :id, :name, :about, :tagline, :location, :slug, :logo, :start, :end
  json.url hackathon_url(hackathon, format: :json)
end
