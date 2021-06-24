require 'rails_helper'

RSpec.describe ItemCategory, type: :model do
  context 'Validations' do
    it { should have_many(:trades) }
    it { should validate_presence_of(:name) }
  end
end
