require 'rails_helper'

RSpec.describe Cooperative, type: :model do
  describe 'associations' do
    it { should have_many :offices }
    it { should have_many :main_offices }
    it { should have_many :branch_offices }
    it { should have_many :satellite_offices }
    it { should have_many :store_fronts }
    it { should have_many :cooperative_services }
    it { should have_many :memberships }
    it { should have_many :member_memberships }
    it { should have_many :bank_accounts }
    it { should have_many :loans }
    it { should have_many :entries }
    it { should have_many :amounts }
    it { should have_many :debit_amounts }
    it { should have_many :credit_amounts }
    it { should have_many :organizations }
    it { should have_many :vouchers }
    it { should have_many :voucher_amounts }
    it { should have_many :users }
    it { should have_many :saving_products }
    it { should have_many :loan_products }
    it { should have_many :interest_configs }
    it { should have_many :time_deposit_products }
    it { should have_many :share_capital_products }
    it { should have_many :programs }
    it { should have_many :program_subscriptions }
    it { should have_many :savings }
    it { should have_many :share_capitals }
    it { should have_many :time_deposits }
    it { should have_many :barangays }
    it { should have_many :municipalities }
    it { should have_many :loan_applications }
    it { should have_many :employee_cash_accounts }
    it { should have_many :cash_accounts }
    it { should have_many :amortization_schedules }
    it { should have_many :registries }
    it { should have_many :loan_registries }
    it { should have_many :stock_registries }
    it { should have_many :member_registries }
    it { should have_many :savings_account_registries }
    it { should have_many :share_capital_registries }
    it { should have_many :time_deposit_registries }
    it { should have_many :bank_account_registries }
    it { should have_many :organization_registries }
    it { should have_many :categories }
    it { should have_many :beneficiaries }
    it { should have_many :savings_account_applications }
    it { should have_many :share_capital_applications }
    it { should have_many :time_deposit_applications }
    it { should have_many :suppliers }
    it { should have_many :products }
    it { should have_many :sales_orders }
    it { should have_many :loan_protection_plan_providers }
    it { should have_many :program_subscription_registries }
    it { should have_many :membership_categories }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :abbreviated_name }
    it { should validate_presence_of :registration_number }
    it { should validate_uniqueness_of :registration_number }
    it { should validate_uniqueness_of :name }
  end
end
