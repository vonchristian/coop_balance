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
      it { is_expected.to belong_to :preparer }
      it { is_expected.to have_one :disbursement_voucher }
    	it { is_expected.to have_many :loan_approvals }
    	it { is_expected.to have_many :approvers }
    	it { is_expected.to have_many :entries }
      it { is_expected.to have_many :loan_charges }
      it { is_expected.to have_many :loan_charge_payment_schedules }
      it { is_expected.to have_many :charges }
      it { is_expected.to have_many :loan_co_makers }
      it { is_expected.to have_many :collaterals }
      it { is_expected.to have_many :real_properties }
      it { is_expected.to have_many :loan_protection_funds }
      it { is_expected.to have_many :terms }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :loan_product_id }
      it { is_expected.to validate_presence_of :borrower_id }
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
      it { is_expected.to delegate_method(:loans_receivable_current_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:unearned_interest_income_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:interest_rate).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:name).to(:organization).with_prefix }
      it { is_expected.to delegate_method(:avatar).to(:borrower) }
      it { is_expected.to delegate_method(:name).to(:barangay).with_prefix }

    end

    it "#current_term" do
      loan = create(:loan)
      old_term = create(:term, termable: loan, effectivity_date: Date.today.last_month)
      current_term = create(:term, termable: loan, effectivity_date: Date.today)

      expect(loan.current_term).to eql(current_term)
    end

    describe 'scopes' do
      it ".not_archived" do
        loan = create(:loan, archived: false)
        archived_loan = create(:loan, archived: true)

        expect(described_class.not_archived).to include(loan)
        expect(described_class.not_archived).to_not include(archived_loan)
      end

      it ".archived" do
        loan = create(:loan, archived: false)
        archived_loan = create(:loan, archived: true)

        expect(described_class.archived).to_not include(loan)
        expect(described_class.archived).to include(archived_loan)
      end

      it ".disbursed(options)" do
        date = Date.today
        disbursed_loan = create(:loan, disbursement_date: date)
        undisbursed_loan = create(:loan)
        entry = create(:entry_with_credit_and_debit, commercial_document: disbursed_loan, entry_date: date)

        expect(LoansModule::Loan.disbursed(from_date: date, to_date: date)).to include(disbursed_loan)
        expect(LoansModule::Loan.disbursed(from_date: date, to_date: date)).to_not include(undisbursed_loan)
      end
    end

    it "#taxable_amount" do
      loan = create(:loan, loan_amount: 100)

      expect(loan.taxable_amount).to eql(100)
    end

    it '#terms_elapsed' do
    end

    it "#maturity_date" do
      loan_product = create(:loan_product_with_interest_config)
      loan = create(:loan_with_interest_on_loan_charge, term: 12, mode_of_payment: 'monthly', loan_product: loan_product, loan_amount: 100_000)
      date = Date.today
      cash_on_hand_account = create(:asset)
      entry = build(:entry, commercial_document: loan, entry_date: date)
      create(:debit_amount, entry: entry, commercial_document: loan,  account: loan_product.loans_receivable_current_account)
      create(:credit_amount, entry: entry, commercial_document: loan, account: cash_on_hand_account )
      entry.save
      loan.update_attributes(disbursement_date: date)
      loan.update_attributes(maturity_date: date + loan.term.to_i.months)

      LoansModule::AmortizationSchedule.create_schedule_for(loan)
      expect(loan.amortization_schedules).to be_present
      expect(loan.maturity_date.to_date).to eql((date + loan.term.to_i.months).to_date)
      expect(loan.disbursed?).to be true
    end
  end
end
