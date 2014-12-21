require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do

  factory :organizer do
    user_id "1"
    hackathon_id "1"
  end


  factory :application do |f|
    f.reimbursement_needed "true"
    f.accepted "true"
    f.user_id "1"
    f.profile_id { Faker::Number.number(4) }
    f.hackathon_id { Faker::Number.number(4) }
  end

  factory :hackathon do |f|
    f.name { Faker::Name.name }
    f.subdomain "testapps"
    f.about { Faker::Lorem.sentence }
    f.tagline { Faker::Lorem.sentence }
    f.location { Faker::Address.city }
    f.start { Faker::Date.backward(14) }
    f.end { Faker::Date.backward(14) }
  end

  factory :like do |f|
    f.user_id { Faker::Number.number(4) }
    f.submission_id { Faker::Number.number(4) }
  end

  factory :oauth_access_token, class: "Doorkeeper::AccessToken" do
    transient do
      user nil
    end

    resource_owner_id { user.try(:id) }
    application_id 1
    token 'abc123'

    trait :with_application do
      association :application, factory: :oauth_application
    end
  end

  factory :oauth_application, class: "Doorkeeper::Application" do
    sequence(:name) { |n| "Application #{n}" }
    sequence(:uid) { |n| n }
    redirect_uri "http://www.example.com/callback"
    owner_id "1"
  end

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
    f.user_id "1"
  end

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

  factory :user do |f|
    f.email { Faker::Internet.email }
    f.password "foobarfoobar"
    f.password_confirmation { |u| u.password }
    f.confirmed_at { Time.now }
  end
end
