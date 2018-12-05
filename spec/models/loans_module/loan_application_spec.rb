require 'rails_helper'

module LoansModule
  describe LoanApplication do
    describe 'associations' do
      it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :borrower }
      it { is_expected.to belong_to :preparer }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :organization }
      it { is_expected.to have_one :loan }
      it { is_expected.to have_many :voucher_amounts }
      it { is_expected.to have_many :amortization_schedules }
      it { is_expected.to have_many :terms }
      it { is_expected.to have_many :amount_adjustments }
    end
    describe 'validations' do
     it {is_expected.to monetize(:loan_amount) }
     it { is_expected.to validate_presence_of(:cooperative_id) }

    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:interest_revenue_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:loans_receivable_current_account).to(:loan_product).with_prefix }
      it { is_expected.to delegate_method(:current_interest_config).to(:loan_product) }
      it { is_expected.to delegate_method(:avatar).to(:borrower) }
      it { is_expected.to delegate_method(:straight_balance?).to(:current_interest_config).with_prefix }
      it { is_expected.to delegate_method(:annually?).to(:current_interest_config).with_prefix }
    end

    it "#term_is_within_one_year?" do
      one_month_loan_application      = create(:loan_application, term: 1)
      twelve_month_loan_application   = create(:loan_application, term: 12)
      thirteen_month_loan_application = create(:loan_application, term: 13)

      expect(one_month_loan_application.term_is_within_one_year?).to be true
      expect(twelve_month_loan_application.term_is_within_one_year?).to be true
      expect(thirteen_month_loan_application.term_is_within_one_year?).to be false
    end

    it "#term_is_within_two_years?" do
      thirteen_month_loan_application = create(:loan_application, term: 13)
      twenty_four_month_loan_application = create(:loan_application, term: 24)
      twenty_five_month_loan_application = create(:loan_application, term: 25)

      expect(one_month_loan_application.term_is_within_two_years?).to be true
      expect(twenty_four_month_loan_application.term_is_within_two_years?).to be true
      expect(twenty_five_month_loan_application.term_is_within_two_years?).to be false
    end

    it "#first_interest" do
      interest_revenue_account = create(:revenue)
      unearned_interest_income_account  = create(:asset)
      loan_product = create(:loan_product)
      loan_product.interest_configs.create!(
        rate: 0.03,
        rate_type: 'monthly_rate',
        amortization_type: 'annually',
        interest_revenue_account: interest_revenue_account,
        unearned_interest_income_account: unearned_interest_income_account)
      loan_application = create(:loan_application, mode_of_payment: 'monthly',  term: 24, loan_amount: 50_000, loan_product: loan_product)
      LoansModule::AmortizationSchedule.create_amort_schedule_for(loan_application)
      puts loan_application.principal_balance(number_of_months: 12)
      expect(loan_application.first_year_interest).to eql 1500.0
      expect(loan_application.second_year_interest).to eql 750.0

    end
  end
end
