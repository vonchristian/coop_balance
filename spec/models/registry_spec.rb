require 'rails_helper'

RSpec.describe Registry, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
  end
end
