require 'rails_helper'
module LoansModule
  describe Loan do
    context 'associations' do
      it { should have_one  :term }
      it { should belong_to :loan_aging_group }
      it { should belong_to :receivable_account }
      it { should belong_to :interest_revenue_account }
      it { should belong_to :penalty_revenue_account }
      it { should belong_to(:accrued_income_account).optional }
      it { should belong_to(:loan_application).optional }
      it { should belong_to(:disbursement_voucher).optional }
      it { should belong_to(:archived_by).optional }
      it { should belong_to :cooperative }
      it { should belong_to :office }
      it { should belong_to :borrower }
      it { should belong_to :loan_product }
      it { should have_many :notices }
      it { should have_many :loan_interests }
      it { should have_many :loan_penalties }
      it { should have_many :loan_discounts }
      it { should have_many :notes }
      it { should have_many :loan_co_makers }
      it { should have_many :member_co_makers }
      it { should have_many :loan_agings }
      it { should have_many :loan_aging_groups }
      it { should have_many :accountable_accounts }
      it { should have_many :accounts }
      it { should have_many :entries }
    end

    describe 'validations' do
      it { should validate_presence_of   :loan_product_id }
      it { should validate_presence_of   :borrower_id }
    end

    context 'delegations' do
      it { should delegate_method(:name).to(:borrower).with_prefix }
      it { should delegate_method(:age).to(:borrower).with_prefix }
      it { should delegate_method(:contact_number).to(:borrower).with_prefix }
      it { should delegate_method(:current_address).to(:borrower).with_prefix }
      it { should delegate_method(:full_name).to(:preparer).with_prefix }
      it { should delegate_method(:current_occupation).to(:preparer).with_prefix }
      it { should delegate_method(:name).to(:loan_product).with_prefix }
      it { should delegate_method(:maximum_loanable_amount).to(:loan_product) }
      it { should delegate_method(:interest_rate).to(:loan_product).with_prefix }
      it { should delegate_method(:name).to(:organization).with_prefix }
      it { should delegate_method(:avatar).to(:borrower) }
      it { should delegate_method(:name).to(:barangay).with_prefix }
      it { should delegate_method(:name).to(:office).with_prefix }
      it { should delegate_method(:name).to(:receivable_account).with_prefix }
      it { should delegate_method(:name).to(:interest_revenue_account).with_prefix }
      it { should delegate_method(:name).to(:penalty_revenue_account).with_prefix }
      it { should delegate_method(:title).to(:loan_aging_group).with_prefix }
    end

    it '#paid?' do
      unpaid_loan = create(:loan, paid_at: nil)
      paid_loan   = create(:loan, paid_at: Date.current)

      expect(unpaid_loan.paid?).to be false
      expect(paid_loan.paid?).to be true
    end

    it '.unpaid' do
      unpaid_loan = create(:loan, paid_at: nil)
      paid_loan   = create(:loan, paid_at: Date.current)

      expect(described_class.unpaid).to include(unpaid_loan)
      expect(described_class.unpaid).not_to include(paid_loan)
    end

    describe 'delegations' do
      it { should delegate_method(:payment_processor).to(:loan_product) }
    end

    describe 'enums' do
      it { should define_enum_for(:status).with_values(%i[current_loan past_due restructured under_litigation]) }
    end

    it '.past_due_loans' do
      past_due_term = create(:term, maturity_date: Time.zone.today.last_month)
      past_due_loan = create(:loan, status: 'past_due', term: past_due_term)
      loan = create(:loan)

      expect(described_class.past_due_loans.pluck(:id)).to include(past_due_loan.id)
      expect(described_class.past_due_loans.pluck(:id)).not_to include(loan.id)
    end

    it '.past_due_loans_on(from_date:, to_date:)' do
      past_due_term   = create(:term, maturity_date: Time.zone.today.last_month)
      past_due_loan   = create(:loan, term: past_due_term)
      past_due_term_2 = create(:term, maturity_date: Time.zone.today.last_year)
      past_due_loan_2 = create(:loan, term: past_due_term_2)

      expect(described_class.past_due_loans_on(from_date: Date.current.last_month, to_date: Date.current.last_month.end_of_month)).to include(past_due_loan)
      expect(described_class.past_due_loans_on(from_date: Date.current.last_month, to_date: Date.current.last_month.end_of_month)).not_to include(past_due_loan_2)
    end

    describe 'scopes' do
      it '.not_archived' do
        loan          = create(:loan, date_archived: nil)
        archived_loan = create(:loan, date_archived: Date.current)

        expect(described_class.not_archived).to include(loan)
        expect(described_class.not_archived).not_to include(archived_loan)
      end

      it '.archived' do
        loan          = create(:loan, date_archived: nil)
        archived_loan = create(:loan, date_archived: Date.current)

        expect(described_class.archived).not_to include(loan)
        expect(described_class.archived).to include(archived_loan)
      end

      it '.disbursed(from_date:, to_date)' do
        date             = Date.current
        entry            = create(:entry_with_credit_and_debit, entry_date: date)
        voucher          = create(:voucher, accounting_entry: entry, date: date)
        disbursed_loan   = create(:loan, disbursement_voucher: voucher)
        undisbursed_loan = create(:loan)

        expect(described_class.disbursed_on(from_date: date, to_date: date)).to include(disbursed_loan)
        expect(described_class.disbursed_on(from_date: date, to_date: date)).not_to include(undisbursed_loan)
      end

      it '.disbursed_by(args={})' do
        employee   = create(:user)
        employee_2 = create(:user)
        voucher    = create(:voucher, disburser: employee)
        loan       = create(:loan, disbursement_voucher: voucher)

        expect(described_class.disbursed_by(employee_id: employee.id)).to include(loan)
        expect(described_class.disbursed_by(employee_id: employee_2.id)).not_to include(loan)
      end
    end
  end
end