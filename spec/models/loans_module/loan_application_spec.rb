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

      expect(thirteen_month_loan_application.term_is_within_two_years?).to be true
      expect(twenty_four_month_loan_application.term_is_within_two_years?).to be true
      expect(twenty_five_month_loan_application.term_is_within_two_years?).to be false
    end

    it "#term_is_within_three_years?" do
      twenty_five_month_loan_application = create(:loan_application, term: 25)
      thirty_six_month_loan_application = create(:loan_application, term: 36)
      thirty_seven_month_loan_application = create(:loan_application, term: 37)

      expect(twenty_five_month_loan_application.term_is_within_three_years?).to be true
      expect(thirty_six_month_loan_application.term_is_within_three_years?).to be true
      expect(thirty_seven_month_loan_application.term_is_within_three_years?).to be false
    end

    it "#term_is_within_four_years?" do
      thirty_seven_month_loan_application = create(:loan_application, term: 37)
      forty_eight_month_loan_application = create(:loan_application, term: 48)
      forty_nine_month_loan_application = create(:loan_application, term: 49)

      expect(thirty_seven_month_loan_application.term_is_within_four_years?).to be true
      expect(forty_eight_month_loan_application.term_is_within_four_years?).to be true
      expect(forty_nine_month_loan_application.term_is_within_four_years?).to be false
    end



    describe "#interest computations" do
       let (:interest_revenue_account)         { create(:revenue) }
       let (:unearned_interest_income_account) { create(:asset) }
       let (:short_term_loan)                     { create(:loan_product) }
       let (:regular_loan)                     { create(:loan_product) }

      it 'first_year_interest' do
        create(:interest_config,
               loan_product: short_term_loan,
               rate: 0.03,
               rate_type: 'monthly_rate',
               amortization_type: 'annually',
               interest_revenue_account: interest_revenue_account,
               unearned_interest_income_account: unearned_interest_income_account)

        short_term_loan_application = create(:loan_application,
          mode_of_payment: 'monthly',
          term: 1.5,
          loan_amount: 5_000,
          loan_product: short_term_loan)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(short_term_loan_application)

        expect(short_term_loan_application.first_year_interest).to eql 225.0
        expect(short_term_loan_application.second_year_interest).to eql 0

      end
      it 'second_year_interest' do
        create(:interest_config,
               loan_product: regular_loan,
               rate: 0.12,
               rate_type: 'annual_rate',
               amortization_type: 'annually',
               interest_revenue_account: interest_revenue_account,
               unearned_interest_income_account: unearned_interest_income_account)

        regular_loan_application = create(:loan_application,
          mode_of_payment: 'monthly',
          term: 18,
          loan_amount: 100_000,
          loan_product: regular_loan)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(regular_loan_application)

        expect(regular_loan_application.first_year_interest).to eq 12_000
        expect(regular_loan_application.second_year_interest).to eq 4_000

      end

      it 'third_year_interest' do
        create(:interest_config,
               loan_product: regular_loan,
               rate: 0.12,
               rate_type: 'annual_rate',
               amortization_type: 'annually',
               interest_revenue_account: interest_revenue_account,
               unearned_interest_income_account: unearned_interest_income_account)

        regular_loan_application = create(:loan_application,
          mode_of_payment: 'monthly',
          term: 36,
          loan_amount: 200_000,
          loan_product: regular_loan)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(regular_loan_application)

        expect(regular_loan_application.first_year_interest).to eq 24_000
        expect(regular_loan_application.second_year_interest).to eq 16_000
        expect(regular_loan_application.third_year_interest).to eq 8_000
      end
    end
  end
end
