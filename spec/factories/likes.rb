require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do

  factory :like do |f|
    f.user_id { Faker::Number.number(4) }
    f.submission_id { Faker::Number.number(4) }
  end

end
