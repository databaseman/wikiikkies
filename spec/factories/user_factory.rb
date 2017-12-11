FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@yahoo.com" }
    password "Password1"
    name "testuser"
  end
end
