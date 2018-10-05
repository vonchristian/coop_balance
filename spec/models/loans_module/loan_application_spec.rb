require 'rails_helper'

module LoansModule
  describe LoanApplication do
    describe 'associations' do
      it { is_expected.to belong_to :borrower }
      it { is_expected.to belong_to :preparer }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :loan_product }
      it { is_expected.to have_many :voucher_amounts }
      it { is_expected.to have_many :amortization_schedules }
      it { is_expected.to have_many :terms }
      it { is_expected.to have_many :amount_adjustments }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:interest_revenue_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:loans_receivable_current_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:current_interest_config).to(:loan_product) }
      it { is_expected.to delegate_method(:avatar).to(:borrower) }

    end
  end
end
