require 'rails_helper'

RSpec.describe CarrefourUnit, type: :model do
  it { should have_many(:trades) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cep) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:suburb) }
end
