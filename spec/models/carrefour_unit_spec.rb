require 'rails_helper'

RSpec.describe CarrefourUnit, type: :model do
  it { should have_many(:trades) }
end
