require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do

  factory :application do |f|
    f.reimbursement_needed "true"
    f.accepted "true"
    f.user_id { Faker::Number.number(4) }
    f.profile_id { Faker::Number.number(4) }
    f.hackathon_id { Faker::Number.number(4) }
  end

end
