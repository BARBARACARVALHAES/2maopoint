require 'rails_helper'

RSpec.describe CarrefourUnit, type: :model do
  context 'Validations' do
    it { should have_many(:trades) }
  end
end
