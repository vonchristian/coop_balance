require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :beneficiaries }
    it { is_expected.to have_many :savings }
    it { is_expected.to have_many :loans }
    it { is_expected.to have_many :share_capitals }
    it { is_expected.to have_many :time_deposits }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of :account_number }
    it { is_expected.to validate_presence_of :account_number }
  end
end
