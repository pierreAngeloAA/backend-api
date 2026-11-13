require "rails_helper"

RSpec.describe "Imports", type: :request do
  let(:headers) { auth_headers(login_as(create(:user))) }
  let(:csv) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/customers.csv"), "text/csv") }

  it "requires authentication" do
    post "/api/v1/imports", params: { file: csv }

    expect(response).to have_http_status(:unauthorized)
  end

  it "stores the file and enqueues the processing job" do
    expect {
      post "/api/v1/imports", params: { file: csv }, headers: headers
    }.to change(Imports::ProcessCsvJob.jobs, :size).by(1)

    expect(response).to have_http_status(:created)
    expect(Import.last).to be_pending
  end

  it "answers 422 without a file" do
    post "/api/v1/imports", headers: headers

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "shows the status and the number of errors" do
    import = create(:import, status: :completed, error_report: "Line 3: x\nLine 5: y")

    get "/api/v1/imports/#{import.id}", headers: headers

    expect(response.parsed_body).to include("status" => "completed", "errors_count" => 2)
  end

  it "downloads the error report" do
    import = create(:import, error_report: "Line 3: Full name can't be blank")

    get "/api/v1/imports/#{import.id}/errors", headers: headers

    expect(response.body).to eq("Line 3: Full name can't be blank")
    expect(response.headers["Content-Disposition"]).to include("import_#{import.id}_errors.txt")
  end

  it "says so when there are no errors" do
    import = create(:import)

    get "/api/v1/imports/#{import.id}/errors", headers: headers

    expect(response.parsed_body).to eq("message" => "No errors found")
  end
end
