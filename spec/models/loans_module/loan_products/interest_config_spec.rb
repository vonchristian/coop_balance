require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestConfig, type: :model do
      it { is_expected.to define_enum_for(:calculation_type).with([:add_on, :prededucted])}
      it { is_expected.to define_enum_for(:amortization_type).with([:annually, :straight_balance])}

      describe 'associations' do
        it { is_expected.to belong_to :cooperative }
        it { is_expected.to belong_to :loan_product }
        it { is_expected.to belong_to :interest_revenue_account }
        it { is_expected.to belong_to :unearned_interest_income_account }

      end

      describe "validations" do
        it { is_expected.to validate_presence_of :rate }
        it { is_expected.to validate_presence_of :unearned_interest_income_account_id }
        it { is_expected.to validate_presence_of :interest_revenue_account_id }
        it { is_expected.to validate_numericality_of :rate }
      end

      it ".current" do
        interest_config = create(:interest_config, created_at: Date.today.yesterday)
        current_interest_config = create(:interest_config, created_at: Date.today)

        expect(described_class.current).to eql current_interest_config
        expect(described_class.current).to_not eql interest_config
      end
      it '.interest_revenue_accounts' do
        interest_config = create(:interest_config)

        expect(described_class.interest_revenue_accounts).to include(interest_config.interest_revenue_account)
      end
      describe "#total_interest(loan_application)" do
          let (:loan_product)  { create(:loan_product) }
          let (:interest_config) { create(:interest_config, rate: 0.12, calculation_type: 'prededucted', loan_product: loan_product) }

        it 'one year' do
          one_year_loan_application = create(:loan_application, term: 12, loan_amount: 100_000, mode_of_payment: 'monthly', loan_product: loan_product)
          LoansModule::AmortizationSchedule.create_amort_schedule_for(one_year_loan_application)

          expect(interest_config.total_interest(one_year_loan_application)).to eql 12_000.0
        end
        it 'two year' do
          two_year_loan_application = create(:loan_application, term: 24, loan_amount: 100_000, mode_of_payment: 'monthly', loan_product: loan_product)
          LoansModule::AmortizationSchedule.create_amort_schedule_for(two_year_loan_application)

          expect(interest_config.total_interest(two_year_loan_application)).to eql 18_000.0
        end
      end
    end
  end
end
