require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :profile do |f|

    f.name { Faker::Name.name }
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { Faker::Internet.email }
    f.school_grad { Faker::Number.number(4) }
    f.bio { Faker::Lorem.sentence }
    f.website { Faker::Internet.domain_name }
    f.github { Faker::Name.first_name }
    f.dietary_needs { Faker::Lorem.sentence }
  end
end
