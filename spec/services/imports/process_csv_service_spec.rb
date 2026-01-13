RSpec.describe Imports::ProcessCsvService do
  it "creates customers from csv" do
    import = create(:import, file: Rack::Test::UploadedFile.new("spec/fixtures/customers.csv", "text/csv"))

    described_class.new(import).call

    expect(Customer.count).to be > 0
  end
end
