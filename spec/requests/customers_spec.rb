require "rails_helper"

RSpec.describe "Customers", type: :request do
  let(:headers) { auth_headers(login_as(create(:user))) }

  it "requires authentication" do
    get "/api/v1/customers"

    expect(response).to have_http_status(:unauthorized)
  end

  it "lists customers" do
    create(:customer, full_name: "Ana Torres")

    get "/api/v1/customers", headers: headers

    expect(response.parsed_body.map { |c| c["full_name"] }).to eq([ "Ana Torres" ])
  end

  it "shows a customer and answers 404 for an unknown one" do
    customer = create(:customer)

    get "/api/v1/customers/#{customer.id}", headers: headers
    expect(response.parsed_body["document"]).to eq(customer.document)

    get "/api/v1/customers/0", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "creates a customer" do
    post "/api/v1/customers", headers: headers, as: :json,
      params: { customer: { document: "555", full_name: "Carlos Perez", email: "carlos@example.com" } }

    expect(response).to have_http_status(:created)
    expect(Customer.find_by(document: "555").full_name).to eq("Carlos Perez")
  end

  it "answers 422 with the errors for invalid data" do
    post "/api/v1/customers", headers: headers, as: :json, params: { customer: { document: "" } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body).to include("document", "full_name")
  end

  it "rejects a duplicated document" do
    create(:customer, document: "777")

    post "/api/v1/customers", headers: headers, as: :json,
      params: { customer: { document: "777", full_name: "Dup", email: "dup@example.com" } }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "updates and deletes a customer" do
    customer = create(:customer)

    patch "/api/v1/customers/#{customer.id}", headers: headers, as: :json, params: { customer: { full_name: "New Name" } }
    expect(customer.reload.full_name).to eq("New Name")

    delete "/api/v1/customers/#{customer.id}", headers: headers
    expect(response).to have_http_status(:no_content)
    expect(Customer.exists?(customer.id)).to be(false)
  end
end
