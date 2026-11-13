require "rails_helper"

RSpec.describe Imports::ProcessCsvJob do
  it "processes the file and marks the import as completed" do
    import = create(:import)

    described_class.new.perform(import.id)

    expect(import.reload).to be_completed
    expect(Customer.count).to eq(3)
  end

  it "marks the import as failed with the reason when processing blows up" do
    import = create(:import)
    allow(Imports::ProcessCsvService).to receive(:new).and_raise(StandardError, "disk full")

    described_class.new.perform(import.id)

    expect(import.reload).to have_attributes(status: "failed", error_report: "disk full")
  end

  it "does nothing when the import no longer exists" do
    expect { described_class.new.perform(0) }.not_to raise_error
  end
end
