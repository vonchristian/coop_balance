require 'rails_helper'
module LoansModule
  describe Loan do
    context 'associations' do
    	it { is_expected.to belong_to :borrower }
      it { is_expected.to belong_to :employee }
    	it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :street }
      it { is_expected.to belong_to :barangay }
      it { is_expected.to belong_to :municipality }
      it { is_expected.to have_one :cash_disbursement_voucher }
    	it { is_expected.to have_many :loan_approvals }
    	it { is_expected.to have_many :approvers }
    	it { is_expected.to have_many :entries }
      it { is_expected.to have_many :loan_charges }
      it { is_expected.to have_many :charges }
      it { is_expected.to have_many :loan_co_makers }
      it { is_expected.to have_many :member_co_makers }
      it { is_expected.to have_many :employee_co_makers }

      it { is_expected.to have_many :notices }
      it { is_expected.to have_many :collaterals }
      it { is_expected.to have_many :real_properties }
      it { is_expected.to have_one :first_notice }
      it { is_expected.to have_one :second_notice }
      it { is_expected.to have_one :third_notice }
      it { is_expected.to have_many :loan_protection_funds }

    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :term }
      it { is_expected.to validate_presence_of :loan_product_id }
      it { is_expected.to validate_numericality_of :term }
    end

    context 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
    	it { is_expected.to delegate_method(:name).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:interest_rate).to(:loan_product).with_prefix }
    end

    it "#taxable_amount" do
      loan = create(:loan, loan_amount: 100)

      expect(loan.taxable_amount).to eql(100)
    end

    it '.disbursed_on(date)' do
      disbursed_loan = create(:loan, loan_status: 'disbursed')
      undisbursed_loan = create(:loan)
      date = Date.today
      entry = create(:entry_with_credit_and_debit, commercial_document: disbursed_loan, entry_date: date)

      expect(LoansModule::Loan.disbursed_on(date)).to include(disbursed_loan)
      expect(LoansModule::Loan.disbursed_on(date)).to_not include(undisbursed_loan)
    end

    it '#terms_elapsed' do
    end
  end
end
