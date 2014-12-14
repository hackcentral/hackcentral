require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do

  factory :user do |f|
    f.email { Faker::Internet.email }
    f.password "foobarfoobar"
    f.password_confirmation { |u| u.password }
    f.confirmed_at { Time.now }
  end

end
