require "rails_helper"

RSpec.describe Auth::JwtService do
  it "round-trips a payload" do
    token = described_class.encode(user_id: 1)

    expect(described_class.decode(token)).to include("user_id" => 1)
  end

  it "returns nil for a tampered token" do
    expect(described_class.decode("#{described_class.encode(user_id: 1)}x")).to be_nil
  end

  it "rejects unsigned tokens (alg: none)" do
    unsigned = JWT.encode({ user_id: 1, exp: 1.hour.from_now.to_i }, nil, "none")

    expect(described_class.decode(unsigned)).to be_nil
  end

  it "returns nil once the token expired" do
    token = described_class.encode(user_id: 1)

    travel(25.hours) { expect(described_class.decode(token)).to be_nil }
  end
end
