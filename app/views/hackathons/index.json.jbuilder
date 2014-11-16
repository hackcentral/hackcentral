json.array!(@hackathons) do |hackathon|
  json.extract! hackathon, :id, :name, :about, :tagline, :location, :subdomain, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned
  json.url hackathon_url(hackathon, format: :json)
end
