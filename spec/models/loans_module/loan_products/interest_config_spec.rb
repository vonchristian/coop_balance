require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestConfig, type: :model do
      it { is_expected.to define_enum_for(:calculation_type).with([:add_on, :prededucted])}
      it { is_expected.to define_enum_for(:amortization_type).with([:annually, :straight_balance])}
      it { is_expected.to define_enum_for(:rate_type).with([:monthly_rate, :annual_rate])}

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
      it "#monthly_rate" do
        monthly_interest_config = create(:interest_config, rate_type: 'monthly_rate', rate: 0.03)
        annual_interest_config  = create(:interest_config, rate_type: 'annual_rate', rate: 0.12)

        expect(monthly_interest_config.monthly_rate).to eql 0.03
        expect(annual_interest_config.monthly_rate). to eql 0.01
      end

      it "#interest_computation(balance)" do
        monthly_interest_config = create(:interest_config, rate_type: 'monthly_rate', rate: 0.03)
        annual_interest_config  = create(:interest_config, rate_type: 'annual_rate', rate: 0.12)

        expect(monthly_interest_config.interest_computation(5_000)).to eq 150
        expect(monthly_interest_config.interest_computation(10_000)).to eq 300
        expect(annual_interest_config.interest_computation(100_000)).to eq 12_000
        expect(annual_interest_config.interest_computation(200_000)).to eq 24_000
      end
      describe '#prededucted_interest(loan_application)' do
        it 'addon interest' do
          interest_config = create(:interest_config, calculation_type: 'add_on')

          expect(interest_config.prededucted_interest(100_000)).to eql 0
        end

        it "#percentage" do
          interest_config = create(:interest_config, prededuction_type: 'percentage', calculation_type: 'prededucted', prededucted_rate: 1.0, rate: 0.12, rate_type: 'annual_rate')

          expect(interest_config.prededucted_interest(100_000)).to eql 12_000
          expect(interest_config.prededucted_interest(200_000)).to eql 24_000

        end
      end
    end
  end
end
