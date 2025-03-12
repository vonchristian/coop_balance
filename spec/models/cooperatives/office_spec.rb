require 'rails_helper'

module Cooperatives
  describe Office do
    describe 'associations' do
      it { should belong_to :cooperative }
      it { should have_many :loans }
      it { should have_many :amortization_schedules }
      it { should have_many :savings }
      it { should have_many :time_deposits }
      it { should have_many :share_capitals }
      it { should have_many :entries }
      it { should have_many :bank_accounts }
      it { should have_many :loan_applications }
      it { should have_many :vouchers }
      it { should have_many :accounts }
      it { should have_many :office_saving_products }
      it { should have_many :saving_products }
      it { should have_many :office_share_capital_products }
      it { should have_many :share_capital_products }
      it { should have_many :office_loan_products }
      it { should have_many :loan_products }
      it { should have_many :office_programs }
      it { should have_many :programs }
      it { should have_many :office_time_deposit_products }
      it { should have_many :time_deposit_products }
      it { should have_many :loan_aging_groups }
      it { should have_many :office_loan_product_aging_groups }
      it { should have_many :level_two_account_categories }
      it { should have_many :level_three_account_categories }
      it { should have_many :time_deposit_applications }
      it { should have_many :share_capital_applications }
      it { should have_one :net_income_config }
    end

    describe 'validations' do
      it { should validate_presence_of :name }
      it { should validate_presence_of :contact_number }
      it { should validate_presence_of :address }
      it { should validate_uniqueness_of :name }
    end

    describe 'delegations' do
      it { should delegate_method(:net_surplus_account).to(:net_income_config) }
      it { should delegate_method(:net_loss_account).to(:net_income_config) }
      it { should delegate_method(:total_revenue_account).to(:net_income_config) }
      it { should delegate_method(:total_expense_account).to(:net_income_config) }
    end

    it '.types' do
      expect(described_class.types).to eql [ 'Cooperatives::Offices::MainOffice', 'Cooperatives::Offices::SatelliteOffice', 'Cooperatives::Offices::BranchOffice' ]
    end
  end
end
