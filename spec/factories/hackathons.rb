require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do

  factory :hackathon do |f|
    f.name { Faker::Name.name }
    f.subdomain { Faker::Name.first_name }
    f.about { Faker::Lorem.sentence }
    f.tagline { Faker::Lorem.sentence }
    f.location { Faker::Address.city }
    f.start { Faker::Date.backward(14) }
    f.end { Faker::Date.backward(14) }
  end

end
