require 'rails_helper'

RSpec.describe Registry, type: :model do
  describe 'associations' do
    it { should belong_to :cooperative }
    it { should belong_to(:store_front).optional }
    it { should belong_to :office }
    it { should belong_to :employee }
  end
end
