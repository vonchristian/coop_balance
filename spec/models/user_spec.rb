require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cash_on_hand_account }
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :store_front }
    it { is_expected.to belong_to :office }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :sales_orders  }
    it { is_expected.to have_many :loans  }
    it { is_expected.to have_many :savings }
    it { is_expected.to have_many :share_capitals }
    it { is_expected.to have_many :time_deposits }
    it { is_expected.to have_many :entries }
    it { is_expected.to have_many :voucher_amounts }
    it { is_expected.to have_many :vouchers }
    it { is_expected.to have_many :prepared_vouchers }
    it { is_expected.to have_many :disbursed_vouchers }
    it { is_expected.to have_many :organization_memberships }
    it { is_expected.to have_many :organizations }
    it { is_expected.to have_one :current_address }
    it { is_expected.to have_many :memberships }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:office).with_prefix }
    it { is_expected.to delegate_method(:name).to(:cooperative).with_prefix }
    it { is_expected.to delegate_method(:abbreviated_name).to(:cooperative).with_prefix }
  end

  describe 'enums' do
    it do
      should define_enum_for(:sex).
      with([:male, :female])
    end
    it do
      should define_enum_for(:role).
        with([:system_administrator,
              :general_manager,
              :branch_manager,
              :loan_officer,
              :bookkeeper,
              :teller,
              :stock_custodian,
              :sales_clerk,
              :treasurer,
              :accountant,
              :accounting_clerk,
              :collector,
              :sales_manager])
    end
  end
end
