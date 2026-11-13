FactoryBot.define do
  factory :import do
    status { :pending }
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/customers.csv"), "text/csv") }
  end
end
