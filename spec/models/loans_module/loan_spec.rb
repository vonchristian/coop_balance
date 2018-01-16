require 'rails_helper'
module LoansModule
  describe Loan do
    context 'associations' do
    	it { is_expected.to belong_to :borrower }
    	it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :street }
      it { is_expected.to belong_to :barangay }
      it { is_expected.to belong_to :municipality }
      it { is_expected.to belong_to :organization }
      it { is_expected.to have_one :disbursement_voucher }
      it { is_expected.to belong_to :preparer }
    	it { is_expected.to have_many :loan_approvals }
    	it { is_expected.to have_many :approvers }
    	it { is_expected.to have_many :entries }
      it { is_expected.to have_many :loan_charges }
      it { is_expected.to have_many :loan_charge_payment_schedules }
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
      it { is_expected.to validate_presence_of :borrower_id }
      it { is_expected.to validate_numericality_of(:term).is_greater_than(0.1) }
      it { is_expected.to validate_numericality_of(:loan_amount) }
    end

    context 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:age).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:contact_number).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_address).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:full_name).to(:preparer).with_prefix }
      it { is_expected.to delegate_method(:current_occupation).to(:preparer).with_prefix }
    	it { is_expected.to delegate_method(:name).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:maximum_loanable_amount).to(:loan_product) }
      it { is_expected.to delegate_method(:account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:penalty_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:interest_account).to(:loan_product).with_prefix }


      it { is_expected.to delegate_method(:interest_rate).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:organization).with_prefix }
      it { is_expected.to delegate_method(:avatar).to(:borrower) }


    end

    it "#taxable_amount" do
      loan = create(:loan, loan_amount: 100)

      expect(loan.taxable_amount).to eql(100)
    end

    it '.disbursed_on(date)' do
      disbursed_loan = create(:loan)
      undisbursed_loan = create(:loan)
      date = Date.today
      entry = create(:entry_with_credit_and_debit, commercial_document: disbursed_loan, entry_date: date)

      expect(LoansModule::Loan.disbursed_on(date)).to include(disbursed_loan)
      expect(LoansModule::Loan.disbursed_on(date)).to_not include(undisbursed_loan)
    end

    it '#terms_elapsed' do
    end

    it "#maturity_date" do
      loan_product = create(:loan_product)
      loan = create(:loan, term: 2, mode_of_payment: 'monthly',  loan_product: loan_product, application_date: Date.today)
      entry = create(:entry_with_credit_and_debit, commercial_document: loan, entry_date: Date.today)
      LoansModule::AmortizationSchedule.create_schedule_for(loan)
      expect(loan.amortization_schedules).to be_present
      expect(loan.maturity_date.to_date).to eql(Date.today + 2.months)
    end
  end
end
