module Alpha
  module Entities
    class Submission < Grape::Entity
      expose :id
      expose :title
      expose :tagline
      expose :description
      expose :video
      expose :website
      expose :created_at
      expose :updated_at
      expose :user_id
      expose :hackathon_id
      expose :submitted_at
      expose :slug
    end
  end

  class Submissions < Grape::API
  end
end