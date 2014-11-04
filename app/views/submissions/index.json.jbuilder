json.array!(@submissions) do |submission|
  json.extract! submission, :id, :title, :tagline, :description, :video, :website
  json.url submission_url(submission, format: :json)
end
