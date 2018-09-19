require 'rails_helper'
module LoansModule
  describe Loan do
    context 'associations' do
      it { is_expected.to have_one :disbursement_voucher }
      it { is_expected.to belong_to :archived_by }
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :borrower }
    	it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :street }
      it { is_expected.to belong_to :barangay }
      it { is_expected.to belong_to :municipality }
      it { is_expected.to belong_to :organization }
      it { is_expected.to belong_to :preparer }
    	it { is_expected.to have_many :entries }
      it { is_expected.to have_many :loan_charges }
      it { is_expected.to have_many :loan_charge_payment_schedules }
      it { is_expected.to have_many :charges }
      it { is_expected.to have_many :terms }
      it { is_expected.to have_many :notices }
      it { is_expected.to have_many :loan_interests }
      it { is_expected.to have_many :loan_penalties }
      it { is_expected.to have_many :loan_discounts }
      it { is_expected.to have_many :notes }

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

    it ".active" do
      loan = create(:loan)
      archived_loan = create(:loan, archived: true)

      expect(described_class.active).to include(loan)
      expect(described_class.active).to_not include(archived_loan)
    end


    it ".past_due(args={})" do
      employee = create(:user, role: 'teller')
      past_due_loan = create(:loan, disbursement_date: Date.today - 2.months)
      past_due_term = create(:term, termable: past_due_loan, maturity_date: Date.today.last_month)
      voucher = create(:voucher, payee: past_due_loan)
      disbursement = build(:entry, commercial_document: voucher, entry_date: Date.today)
      disbursement.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: past_due_loan, account: past_due_loan.loan_product.loans_receivable_current_account)
      disbursement.credit_amounts << create(:credit_amount, amount: 5_000, commercial_document: past_due_loan, account: employee.cash_on_hand_account)
      disbursement.save

      loan = create(:loan)

      expect(past_due_loan.disbursed?).to be true
      expect(described_class.past_due.pluck(:id)).to include(past_due_loan.id)
      expect(described_class.past_due.pluck(:id)).to_not include(loan.id)
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

      it ".disbursed_by(args={})" do
        employee = create(:user)
        loan = create(:loan)
        voucher = create(:voucher, disburser: employee)
        entry = create(:entry_with_credit_and_debit)
        voucher.accounting_entry = entry
        loan.voucher = voucher

        expect(loan.disbursed?).to eql true
        expect(described_class.disbursed).to include(loan)
        # expect(described_class.disbursed_by(employee_id: employee.id)).to include(loan)
      end
    end

    it "#taxable_amount" do
      loan = create(:loan, loan_amount: 100)

      expect(loan.taxable_amount).to eql(100)
    end

    it '#terms_elapsed' do
    end
  end
end
