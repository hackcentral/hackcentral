module Alpha

  module Entities
    class Profile < Grape::Entity
      expose :name
      expose :school_grad
      expose :website
      expose :github
      expose :created_at
      expose :updated_at
      expose :resume_url
      expose :dietary_needs
      expose :user_id
  end
    end
  end

  class Profiles < Grape::API
  end
end