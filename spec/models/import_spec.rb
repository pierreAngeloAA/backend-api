require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should define_enum_for(:status).with_values(pending: 0, processing: 1, completed: 2, failed: 3) }
end
