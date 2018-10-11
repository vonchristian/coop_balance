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
    it { is_expected.to have_many :bank_accounts }
    it { is_expected.to have_many :loans }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :organizations }
    it { is_expected.to have_many :vouchers }
    it { is_expected.to have_many :users }
    it { is_expected.to have_many :saving_products }
    it { is_expected.to have_many :loan_products }
    it { is_expected.to have_many :time_deposit_products }
    it { is_expected.to have_many :share_capital_products }
    it { is_expected.to have_many :programs }
    it { is_expected.to have_many :cooperative_services }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :abbreviated_name }
    it { is_expected.to validate_presence_of :registration_number }
    it { is_expected.to validate_uniqueness_of :registration_number }
    it { is_expected.to validate_uniqueness_of :name }
  end
end
