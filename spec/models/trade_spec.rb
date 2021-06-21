require 'rails_helper'

RSpec.describe Trade, type: :model do
  it { should belong_to(:seller).optional }
  it { should belong_to(:buyer).optional }
  it { should belong_to(:item_category) } 
  it { should belong_to(:carrefour_unit) } 
end
