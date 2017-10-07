FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "test#{n}" }
    description "testing"
  end
end
