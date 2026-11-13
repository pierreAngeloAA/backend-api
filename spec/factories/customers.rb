FactoryBot.define do
  factory :customer do
    sequence(:document) { |n| "10#{n}" }
    full_name { "Ana Torres" }
    email { "ana@example.com" }
    phone { "3001112222" }
  end
end
