require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :organization_members }
    it { is_expected.to have_many :members }
  end
end
