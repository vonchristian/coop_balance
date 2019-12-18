require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestConfig do
      it { is_expected.to define_enum_for(:calculation_type).with_values([:add_on, :prededucted, :accrued])}

      describe 'associations' do
        it { is_expected.to belong_to :cooperative }
        it { is_expected.to belong_to :loan_product }
        it { is_expected.to belong_to :interest_revenue_account }
        it { is_expected.to belong_to :unearned_interest_income_account }
        it { is_expected.to belong_to :accrued_income_account }

      end

      describe "validations" do
        it { is_expected.to validate_presence_of :rate }
        it { is_expected.to validate_presence_of :unearned_interest_income_account_id }
        it { is_expected.to validate_presence_of :interest_revenue_account_id }
        it { is_expected.to validate_numericality_of :rate }
      end

      it ".current" do
        interest_config         = create(:interest_config, created_at: Date.current.last_year)
        current_interest_config = create(:interest_config, created_at: Date.current)

        expect(described_class.current.id).to eql current_interest_config.id
        expect(described_class.current.id).to_not eql interest_config.id
      end

      it '.interest_revenue_accounts' do
        interest_config = create(:interest_config)

        expect(described_class.interest_revenue_accounts).to include(interest_config.interest_revenue_account)
      end

      it "#compute_interest" do
        interest_config = create(:interest_config, rate: 0.12)
        interest_config_2 = create(:interest_config, rate: 0.17)

        expect(interest_config.compute_interest(amount: 100_000, number_of_days: 365)).to eq 12_000
        expect(interest_config_2.compute_interest(amount: 100_000, number_of_days: 365).to_f).to eq 17_000.0
      end

      it "#monthly_interest_rate" do
        interest_config = build_stubbed(:interest_config, rate: 0.12)

        expect(interest_config.monthly_interest_rate).to eql 0.01
      end

      it "#applicable_term" do
        expect(described_class.new.applicable_term(365)).to eql 12
        expect(described_class.new.applicable_term(45)).to eql 1.5
        expect(described_class.new.applicable_term(29)).to eql 1
        expect(described_class.new.applicable_term(30)).to eq 1



      end
    end
  end
end
