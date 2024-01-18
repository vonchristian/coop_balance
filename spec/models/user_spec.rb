require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to :cooperative }
    it { should belong_to :office }
    it { should have_many :carts }
    it { should have_many :entries }
    it { should have_many :purchases }
    it { should have_many :sales_orders }
    it { should have_many :loans }
    it { should have_many :savings }
    it { should have_many :share_capitals }
    it { should have_many :time_deposits }
    it { should have_many :entries }
    it { should have_many :voucher_amounts }
    it { should have_many :vouchers }
    it { should have_many :prepared_vouchers }
    it { should have_many :disbursed_vouchers }
    it { should have_many :organization_memberships }
    it { should have_many :organizations }
    it { should have_many :addresses }
    it { should have_many :memberships }
    it { should have_many :employee_cash_accounts }
    it { should have_many :cash_accounts }
    it { should have_many :memberships }
    it { should have_many :program_subscriptions }
    it { should have_many :subscribed_programs }
  end

  describe 'delegations' do
    it { should delegate_method(:name).to(:office).with_prefix }
    it { should delegate_method(:name).to(:cooperative).with_prefix }
    it { should delegate_method(:address).to(:cooperative).with_prefix }
    it { should delegate_method(:contact_number).to(:cooperative).with_prefix }
    it { should delegate_method(:abbreviated_name).to(:cooperative).with_prefix }
    it { should delegate_method(:logo).to(:cooperative).with_prefix }
    it { should delegate_method(:name).to(:store_front).with_prefix }
  end

  describe 'enums' do
    it do
      expect(subject).to define_enum_for(:sex)
        .with_values(%i[male female])
    end

    it do
      expect(subject).to define_enum_for(:role)
        .with_values(%i[system_administrator
                        general_manager
                        branch_manager
                        loan_officer
                        bookkeeper
                        teller
                        stock_custodian
                        sales_clerk
                        treasurer
                        accountant
                        collector])
    end
  end
end
