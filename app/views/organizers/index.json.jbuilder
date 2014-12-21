json.array!(@organizers) do |organizer|
  json.extract! organizer, :id, :user_id, :hackathon_id
  json.url organizer_url(organizer, format: :json)
end
