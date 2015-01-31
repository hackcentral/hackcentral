module Alpha
  class Applications < Grape::API

    module Entities
    class Application < Grape::Entity
      expose :id
      expose :reimbursement_needed, documentation: { type: "Boolean", desc: "If user needs travel reimbursement" }
      expose :profile_id, documentation: { type: "Integer", desc: "ID of profile" }
      expose :hackathon_id, documentation: { type: "Integer", desc: "ID of hackathon applying to" }
      expose :created_at
      expose :updated_at
    end
  end


  end
end