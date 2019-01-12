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

    it "#net_proceed" do
      interest_revenue_account         = create(:revenue)
      unearned_interest_income_account = create(:asset)
      loan_protection_account          = create(:liability)
      regular_loan                     = create(:loan_product)
      interest_config                  = create(:interest_config,
                                         loan_product: regular_loan,
                                         rate: 0.12,
                                         rate_type: 'annual_rate',
                                         amortization_type: 'annually',
                                         prededuction_type: 'percentage',
                                         prededucted_rate: 1,
                                         calculation_type: 'prededucted',
                                         interest_revenue_account: interest_revenue_account,
                                         unearned_interest_income_account: unearned_interest_income_account)

      regular_loan_application = create(:loan_application,
        mode_of_payment: 'monthly',
        term: 36,
        loan_amount: 200_000,
        loan_product: regular_loan)

      regular_loan.create_charges_for(regular_loan_application)
      LoansModule::AmortizationSchedule.create_amort_schedule_for(regular_loan_application)
      lpp = create(:voucher_amount, amount: 1_000, account: loan_protection_account, loan_application: regular_loan_application)
      expect(regular_loan_application.total_interest).to eq 48_000
      expect(regular_loan_application.voucher_interest_amount).to eq 24_000
      expect(regular_loan_application.interest_balance).to eq 24_000
      expect(regular_loan_application.net_proceed).to eql 175_000
    end

    describe '#interest balance computation' do
      let (:interest_revenue_account)         { create(:revenue) }
      let (:unearned_interest_income_account) { create(:asset) }
      let (:short_term_loan)                     { create(:loan_product) }
      let (:regular_loan)                     { create(:loan_product) }

      it 'with zero balance' do
        create(:interest_config,
          loan_product: short_term_loan,
          rate: 0.03,
          rate_type: 'monthly_rate',
          amortization_type: 'annually',
          prededuction_type: 'percentage',
          prededucted_rate: 1,
          calculation_type: 'prededucted',
          interest_revenue_account: interest_revenue_account,
          unearned_interest_income_account: unearned_interest_income_account)

        short_term_loan_application = create(:loan_application,
          mode_of_payment: 'monthly',
          term: 1.5,
          loan_amount: 5_000,
          loan_product: short_term_loan)

        short_term_loan.create_charges_for(short_term_loan_application)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(short_term_loan_application)

        expect(short_term_loan_application.total_interest).to eql 225.0
        expect(short_term_loan_application.voucher_interest_amount).to eql 225.0
        expect(short_term_loan_application.interest_balance).to eql 0
      end
      it "#with balance" do
        create(:interest_config,
               loan_product: regular_loan,
               rate: 0.12,
               rate_type: 'annual_rate',
               amortization_type: 'annually',
               prededuction_type: 'percentage',
               prededucted_rate: 1,
               calculation_type: 'prededucted',
               interest_revenue_account: interest_revenue_account,
               unearned_interest_income_account: unearned_interest_income_account)

        regular_loan_application = create(:loan_application,
          mode_of_payment: 'monthly',
          term: 36,
          loan_amount: 200_000,
          loan_product: regular_loan)

        regular_loan.create_charges_for(regular_loan_application)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(regular_loan_application)

        expect(regular_loan_application.total_interest).to eq 48_000
        expect(regular_loan_application.voucher_interest_amount).to eq 24_000
        expect(regular_loan_application.interest_balance).to eq 24_000

      end
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

      it "#schedule_counter" do
        loan_application_daily = create(:loan_application, mode_of_payment: 'daily')
        loan_application_weekly = create(:loan_application, mode_of_payment: 'weekly')
        loan_application_monthly = create(:loan_application, mode_of_payment: 'monthly')
        loan_application_quarterly = create(:loan_application, mode_of_payment: 'quarterly')
        loan_application_semi_annually = create(:loan_application, mode_of_payment: 'semi_annually')
        loan_application_lumpsum = create(:loan_application, mode_of_payment: 'lumpsum')

        expect(loan_application_daily.schedule_counter).to eql LoansModule::ScheduleCounters::DailyCounter
        expect(loan_application_weekly.schedule_counter).to eql LoansModule::ScheduleCounters::WeeklyCounter
        expect(loan_application_monthly.schedule_counter).to eql LoansModule::ScheduleCounters::MonthlyCounter
        expect(loan_application_quarterly.schedule_counter).to eql LoansModule::ScheduleCounters::QuarterlyCounter
        expect(loan_application_semi_annually.schedule_counter).to eql LoansModule::ScheduleCounters::SemiAnnuallyCounter
        expect(loan_application_lumpsum.schedule_counter).to eql LoansModule::ScheduleCounters::LumpsumCounter
      end

      it "#amortizeable_principal" do
        loan_application_daily = create(:loan_application, term: 12, mode_of_payment: 'daily', loan_amount: 100_000)
        loan_application_weekly = create(:loan_application, term: 12, mode_of_payment: 'weekly',loan_amount: 100_000)
        loan_application_monthly = create(:loan_application, term: 12, mode_of_payment: 'monthly',loan_amount: 100_000)
        loan_application_quarterly = create(:loan_application, term: 12, mode_of_payment: 'quarterly',loan_amount: 100_000)
        loan_application_semi_annually = create(:loan_application, term: 12, mode_of_payment: 'semi_annually',loan_amount: 100_000)
        loan_application_lumpsum = create(:loan_application, term: 12, mode_of_payment: 'lumpsum',loan_amount: 100_000)

        expect(loan_application_daily.amortizeable_principal).to eql 277.78
        expect(loan_application_weekly.amortizeable_principal).to eql 2_083.33
        expect(loan_application_monthly.amortizeable_principal).to eql 8_333.33
        expect(loan_application_quarterly.amortizeable_principal).to eql 25_000.00
        expect(loan_application_semi_annually.amortizeable_principal).to eql 50_000.00
        expect(loan_application_lumpsum.amortizeable_principal).to eql 100_000.00
      end

      it "#amortization_date_setter" do
        loan_application_daily = create(:loan_application, mode_of_payment: 'daily')
        loan_application_weekly = create(:loan_application, mode_of_payment: 'weekly')
        loan_application_monthly = create(:loan_application, mode_of_payment: 'monthly')
        loan_application_quarterly = create(:loan_application, mode_of_payment: 'quarterly')
        loan_application_semi_annually = create(:loan_application, mode_of_payment: 'semi_annually')
        loan_application_lumpsum = create(:loan_application, mode_of_payment: 'lumpsum')

        expect(loan_application_daily.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::Daily
        expect(loan_application_weekly.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::Weekly
        expect(loan_application_monthly.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::Monthly
        expect(loan_application_quarterly.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::Quarterly
        expect(loan_application_semi_annually.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::SemiAnnually
        expect(loan_application_lumpsum.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::Lumpsum
      end

      it "#interest_amortization_calculator" do
        number_of_payments_loan_product = create(:loan_product)
        percent_base_loan_product       = create(:loan_product)
        number_of_payments              = create(:interest_prededuction, number_of_payments: 3, loan_product: number_of_payments_loan_product)
        percent_based                   = create(:interest_prededuction, rate: 0.75, loan_product: percent_base_loan_product)
        loan_application_1              = create(:loan_application, loan_product: number_of_payments_loan_product)
        loan_application_2              = create(:loan_application, loan_product: percent_base_loan_product)

        expect()
      end

      it "#principal_balance(schedule)" do
        amortization_type     = create(:amortization_type, calculation_type: 'straight_line')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, rate: 0.75, calculation_type: 'percent_based')
        interest_config       = create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
        loan_application      = create(:loan_application, loan_product: loan_product, loan_amount: 100_000, term: 24, mode_of_payment: 'monthly', application_date: Date.current)

        LoansModule::AmortizationScheduler.new(scheduleable: loan_application).create_schedule!
        puts loan_application.schedule_count
        puts loan_application.loan_amount.amount
        schedule = loan_application.amortization_schedules.by_oldest_date[11]
        expect(loan_application.principal_balance_for(schedule)).to eql 50_000.00
      end

    end
  end
end
