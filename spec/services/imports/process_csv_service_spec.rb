require "rails_helper"

RSpec.describe Imports::ProcessCsvService do
  def import_of(fixture)
    create(:import, file: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures", fixture), "text/csv"))
  end

  it "creates customers from csv" do
    described_class.new(import_of("customers.csv")).call

    expect(Customer.pluck(:document)).to contain_exactly("1001", "1002", "1003")
  end

  it "updates existing customers by document instead of duplicating them" do
    create(:customer, document: "1001", full_name: "Old Name")

    described_class.new(import_of("customers.csv")).call

    expect(Customer.where(document: "1001").count).to eq(1)
    expect(Customer.find_by(document: "1001").full_name).to eq("Ana Torres")
  end

  it "skips invalid rows and reports them with their CSV line number" do
    import = import_of("customers_with_errors.csv")

    described_class.new(import).call

    expect(Customer.pluck(:document)).to eq([ "2001" ])
    expect(import.reload.error_report).to start_with("Line 3:")
  end
end
