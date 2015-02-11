module Alpha

  module Entities
    class Hackathon < Grape::Entity
      expose :id
      expose :name
      expose :about
      expose :tagline
      expose :location
      expose :created_at
      expose :updated_at
      expose :start
      expose :end
      expose :hs_hackers_allowed, documentation: { type: "Boolean", desc: "If HS Hackers are allowed" }
      expose :mlh_sanctioned, documentation: { type: "Boolean", desc: "If hackathon has been sanctioned by MLH" }
      expose :subdomain
      expose :user_id
    end
  end

  class Hackathons < Grape::API
  end
end