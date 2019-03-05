require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do
      it { is_expected.to belong_to :loan_protection_plan_provider }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :current_account }
      it { is_expected.to belong_to :past_due_account }
      it { is_expected.to belong_to :restructured_account }
      it { is_expected.to belong_to :litigation_account }
    	it { is_expected.to have_many :loans }
      it { is_expected.to have_many :member_borrowers }
      it { is_expected.to have_many :employee_borrowers }
      it { is_expected.to have_many :organization_borrowers }
    	it { is_expected.to have_many :loan_product_charges }
      it { is_expected.to have_many :interest_configs }
      it { is_expected.to have_many :penalty_configs }
      it { is_expected.to have_many :interest_predeductions }
      it { is_expected.to have_many :loan_applications }
    end

    describe 'delegations' do
      let(:loan_product) { create(:loan_product_with_interest_config)}
        it { is_expected.to delegate_method(:rate).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:amortization_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:prededuction_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:prededucted_rate).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:calculation_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:rate_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:interest_revenue_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:interest_receivable_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:unearned_interest_income_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:penalty_receivable_account).to(:current_penalty_config) }
        it { is_expected.to delegate_method(:penalty_revenue_account).to(:current_penalty_config) }
        it { is_expected.to delegate_method(:scheduler).to(:amortization_type).with_prefix }
        it { is_expected.to delegate_method(:calculation_type).to(:current_interest_prededuction).with_prefix }
        it { is_expected.to delegate_method(:rate).to(:current_interest_prededuction).with_prefix }
        it { is_expected.to delegate_method(:number_of_payments).to(:current_interest_prededuction).with_prefix }

    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :current_account_id }
    end

    describe 'annual_interest_calculator' do
      it "straight_line" do
        straight_line = create(:amortization_type, calculation_type: 'straight_line')
        straight_line_loan_product = create(:loan_product, amortization_type: straight_line)

        expect(straight_line_loan_product.annual_interest_calculator).to eql LoansModule::AnnualInterestCalculators::StraightLine
      end

      it "declining_balance" do
        declining_balance = create(:amortization_type, calculation_type: 'declining_balance')
        declining_balance_loan_product = create(:loan_product, amortization_type: declining_balance)

        expect(declining_balance_loan_product.annual_interest_calculator).to eql LoansModule::AnnualInterestCalculators::DecliningBalance
      end
    end

    describe "interest_charge_setter" do
      it "add_on" do
        loan_product = create(:loan_product)
        interest_config = create(:add_on_interest_config, loan_product: loan_product)

        expect(loan_product.interest_charge_setter).to eql LoansModule::InterestChargeSetters::AddOn
      end

      it "prededucted" do
        loan_product = create(:loan_product)
        interest_config = create(:prededucted_interest_config, loan_product: loan_product)

        expect(loan_product.interest_charge_setter).to eql LoansModule::InterestChargeSetters::Prededucted
      end

      it "accrued" do
        loan_product = create(:loan_product)
        interest_config = create(:accrued_interest_config, loan_product: loan_product)

        expect(loan_product.interest_charge_setter).to eql LoansModule::InterestChargeSetters::Accrued
      end
    end


    describe "#interest_calculator" do
      it 'returns percent based straight line' do
        straight_line_amortization_type = create(:amortization_type, calculation_type: 'straight_line')
        loan_product = create(:loan_product, amortization_type: straight_line_amortization_type)
        interest_config = create(:interest_config, calculation_type: 'prededucted', loan_product: loan_product)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, calculation_type: 'percent_based')

        expect(loan_product.interest_calculator).to eq LoansModule::InterestCalculators::PercentBasedStraightLine
      end

      it 'returns percent based declining balance for loan product with percent based interest prededuction and declining_balance amortization type' do
        declining_balance_amortization_type = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product = create(:loan_product, amortization_type: declining_balance_amortization_type)
        interest_config = create(:interest_config, calculation_type: 'prededucted', loan_product: loan_product)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, calculation_type: 'percent_based')

        expect(loan_product.interest_calculator).to eq LoansModule::InterestCalculators::PercentBasedDecliningBalance
      end

      it 'returns number_of_payments based for loan product with number of payments based interest prededuction and declining_balance amortization type' do
        declining_balance_amortization_type = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product = create(:loan_product, amortization_type: declining_balance_amortization_type)
        interest_config = create(:interest_config, calculation_type: 'prededucted', loan_product: loan_product)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, calculation_type: 'number_of_payments_based')

        expect(loan_product.interest_calculator).to eq LoansModule::InterestCalculators::NumberOfPaymentsBasedDecliningBalance
      end
    end
  end
end
