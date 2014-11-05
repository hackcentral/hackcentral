json.array!(@submissions) do |submission|
  json.extract! submission, :id, :title, :tagline, :description, :video, :website, :user_id, :hackathon_id
  json.url hackathon_submission_path(@hackathon, submission, format: :json)
end
