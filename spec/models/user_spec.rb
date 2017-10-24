require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do 
    it { is_expected.to belong_to :department }
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :salary_grade }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :appraised_properties }
    it { is_expected.to have_many :orders  }
    it { is_expected.to have_many :loans  }
    it { is_expected.to have_many :savings }
    it { is_expected.to have_many :share_capitals }
    it { is_expected.to have_many :time_deposits }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :fund_transfers }
    it { is_expected.to have_many :voucher_amounts }
    it { is_expected.to have_many :vouchers }
    it { is_expected.to have_many :employee_contributions }
    it { is_expected.to have_many :contributions }
    it { is_expected.to have_many :real_properties }
    it { is_expected.to have_one :current_address }
  end

  describe 'delegations' do 
    it { is_expected.to delegate_method(:amount).to(:salary_grade).with_prefix }
    it { is_expected.to delegate_method(:name).to(:salary_grade).with_prefix }
    it { is_expected.to delegate_method(:name).to(:department).with_prefix }
  end
  describe 'enums' do 
    it do
      should define_enum_for(:sex).
      with([:male, :female, :others])
    end
    it do
      should define_enum_for(:role).
        with([:system_administrator, 
              :manager, 
              :loan_officer, 
              :bookkeeper, 
              :teller, 
              :stock_custodian, 
              :sales_clerk, 
              :treasurer, 
              :accountant, 
              :human_resource_officer, 
              :accounting_clerk])
    end
  end
end
