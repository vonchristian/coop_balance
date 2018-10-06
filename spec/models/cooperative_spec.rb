require 'rails_helper'

RSpec.describe Cooperative, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to :interest_amortization_config }
    it { is_expected.to have_many :offices }
    it { is_expected.to have_many :store_fronts }
    it { is_expected.to have_many :cooperative_services }
    it { is_expected.to have_many :accountable_accounts }
    it { is_expected.to have_many :accounts }
    it { is_expected.to have_many :memberships }
    it { is_expected.to have_many :member_memberships }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :abbreviated_name }
    it { is_expected.to validate_presence_of :registration_number }
    it { is_expected.to validate_uniqueness_of :registration_number }
    it { is_expected.to validate_uniqueness_of :name }
  end
end
