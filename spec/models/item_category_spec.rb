require 'rails_helper'

RSpec.describe ItemCategory, type: :model do
  it { should have_many(:trades) }
end
