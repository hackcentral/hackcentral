json.array!(@hackathons) do |hackathon|
  json.extract! hackathon, :id, :name, :about, :tagline, :location, :subdomain, :logo, :header, :start, :end
  json.url hackathon_url(hackathon, format: :json)
end
