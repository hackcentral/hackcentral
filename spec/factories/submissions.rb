require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do

  factory :submission do |f|
    f.title { Faker::Name.name }
    f.tagline { Faker::Lorem.sentence }
    f.description { Faker::Lorem.sentence }
    f.video { Faker::Internet.url }
    f.website { Faker::Internet.domain_name }
    f.submitted_at { Faker::Date.backward(14) }
    f.user_id { Faker::Number.number(4) }
    f.hackathon_id { Faker::Number.number(4) }
  end

end
