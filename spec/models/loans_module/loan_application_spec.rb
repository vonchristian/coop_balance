require 'rails_helper'

module LoansModule
  describe LoanApplication do
    describe 'associations' do
      it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :borrower }
      it { is_expected.to belong_to :preparer }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to(:cart).optional }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to(:organization).optional }
      it { is_expected.to belong_to(:voucher).optional }
      it { is_expected.to belong_to :receivable_account }
      it { is_expected.to belong_to :interest_revenue_account }
      it { is_expected.to have_one :loan }
      it { is_expected.to have_many :voucher_amounts }
      it { is_expected.to have_many :amortization_schedules }
      it { is_expected.to have_many :terms }
    end

    describe 'validations' do
     it {is_expected.to monetize(:loan_amount) }
     it { is_expected.to validate_presence_of :account_number }
     it { is_expected.to validate_presence_of :number_of_days }
     it { is_expected.to validate_numericality_of(:number_of_days).only_integer }
     it 'unique account_number' do
       loan_application = create(:loan_application, account_number: '1')
       loan_application_2 = build(:loan_application, account_number: '1')
       loan_application_2.save
       expect(loan_application_2.errors[:account_number]).to eq ['has already been taken']
     end
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_interest_config).to(:loan_product) }
      it { is_expected.to delegate_method(:amortization_type).to(:loan_product) }

      it { is_expected.to delegate_method(:avatar).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:straight_balance?).to(:current_interest_config).with_prefix }
      it { is_expected.to delegate_method(:annually?).to(:current_interest_config).with_prefix }
    end

    describe "enums" do 
      it { define_enum_for(:mode_of_payment).with_values([:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :annually])}
    end 

    
    
    it "#term_is_within_one_year?" do
      one_month_loan_application      = create(:loan_application, number_of_days: 30)
      twelve_month_loan_application   = create(:loan_application, number_of_days: 365)
      thirteen_month_loan_application = create(:loan_application, number_of_days: 395)

      expect(one_month_loan_application.term_is_within_one_year?).to be true
      expect(twelve_month_loan_application.term_is_within_one_year?).to be true
      expect(thirteen_month_loan_application.term_is_within_one_year?).to be false
    end

    it "#term_is_within_two_years?" do
      thirteen_month_loan_application    = create(:loan_application, number_of_days: 395)
      twenty_four_month_loan_application = create(:loan_application, number_of_days: 730)
      twenty_five_month_loan_application = create(:loan_application, number_of_days: 760)

      expect(thirteen_month_loan_application.term_is_within_two_years?).to be true
      expect(twenty_four_month_loan_application.term_is_within_two_years?).to be true
      expect(twenty_five_month_loan_application.term_is_within_two_years?).to be false
    end

    it "#term_is_within_three_years?" do
      twenty_five_month_loan_application  = create(:loan_application, number_of_days: 731)
      thirty_six_month_loan_application   = create(:loan_application, number_of_days: 761)
      thirty_seven_month_loan_application = create(:loan_application, number_of_days: 1096)

      expect(twenty_five_month_loan_application.term_is_within_three_years?).to be true
      expect(thirty_six_month_loan_application.term_is_within_three_years?).to be true
      expect(thirty_seven_month_loan_application.term_is_within_three_years?).to be false
    end

    it "#term_is_within_four_years?" do
      days_1096 = create(:loan_application, number_of_days: 1096)
      days_1110 = create(:loan_application, number_of_days: 1110)
      days_1461 = create(:loan_application, number_of_days: 1461)

      expect(days_1096.term_is_within_four_years?).to be true
      expect(days_1110.term_is_within_four_years?).to be true
      expect(days_1461.term_is_within_four_years?).to be false
    end

    it "#term_is_within_five_years?" do
      days_1461 = create(:loan_application, number_of_days: 1461)
      days_1825 = create(:loan_application, number_of_days: 1825)
      days_1826 = create(:loan_application, number_of_days: 1826)

      expect(days_1461.term_is_within_five_years?).to be true
      expect(days_1825.term_is_within_five_years?).to be true
      expect(days_1826.term_is_within_five_years?).to be false
    end

      it "#schedule_counter" do
        daily         = create(:loan_application, mode_of_payment: 'daily')
        weekly        = create(:loan_application, mode_of_payment: 'weekly')
        monthly       = create(:loan_application, mode_of_payment: 'monthly')
        quarterly     = create(:loan_application, mode_of_payment: 'quarterly')
        semi_annually = create(:loan_application, mode_of_payment: 'semi_annually')
        lumpsum       = create(:loan_application, mode_of_payment: 'lumpsum')

        expect(daily.schedule_counter).to eql         LoansModule::ScheduleCounters::DailyCounter
        expect(weekly.schedule_counter).to eql        LoansModule::ScheduleCounters::WeeklyCounter
        expect(monthly.schedule_counter).to eql       LoansModule::ScheduleCounters::MonthlyCounter
        expect(quarterly.schedule_counter).to eql     LoansModule::ScheduleCounters::QuarterlyCounter
        expect(semi_annually.schedule_counter).to eql LoansModule::ScheduleCounters::SemiAnnuallyCounter
        expect(lumpsum.schedule_counter).to eql       LoansModule::ScheduleCounters::LumpsumCounter
      end

     

      it "#amortization_date_setter" do
        daily         = create(:loan_application, mode_of_payment: 'daily')
        weekly        = create(:loan_application, mode_of_payment: 'weekly')
        monthly       = create(:loan_application, mode_of_payment: 'monthly')
        quarterly     = create(:loan_application, mode_of_payment: 'quarterly')
        semi_annually = create(:loan_application, mode_of_payment: 'semi_annually')
        lumpsum       = create(:loan_application, mode_of_payment: 'lumpsum')

        expect(daily.amortization_date_setter).to         eql LoansModule::AmortizationDateSetters::Daily
        expect(weekly.amortization_date_setter).to        eql LoansModule::AmortizationDateSetters::Weekly
        expect(monthly.amortization_date_setter).to       eql LoansModule::AmortizationDateSetters::Monthly
        expect(quarterly.amortization_date_setter).to     eql LoansModule::AmortizationDateSetters::Quarterly
        expect(semi_annually.amortization_date_setter).to eql LoansModule::AmortizationDateSetters::SemiAnnually
        expect(lumpsum.amortization_date_setter).to       eql LoansModule::AmortizationDateSetters::Lumpsum
      end
    end
  end
