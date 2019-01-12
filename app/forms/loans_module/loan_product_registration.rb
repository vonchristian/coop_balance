module LoansModule
  class LoanProductRegistration
    include ActiveModel::Model
    attr_accessor :name, :id,
    :description,
    :maximum_loanable_amount,
    :current_account_id,
    :past_due_account_id,
    :interest_rate,
    :interest_revenue_account_id,
    :unearned_interest_income_account_id,
    :penalty_rate,
    :penalty_revenue_account_id,
    :loan_protection_plan_provider_id,
    :cooperative_id,
    :grace_period,
    :amortization_type_id,
    :interest_calculation_type

    validates :name, :maximum_loanable_amount,
    :current_account_id,
    :past_due_account_id,
    :interest_rate,
    :interest_revenue_account_id,
    :unearned_interest_income_account_id,
    :penalty_rate,
    :penalty_revenue_account_id,
    :cooperative_id,
    :grace_period, presence: true

    validates :maximum_loanable_amount, :grace_period, :interest_rate, :penalty_rate, numericality: true


    def register!
      ActiveRecord::Base.transaction do
        create_loan_product
      end
    end
    def find_cooperative
      Cooperative.find(cooperative_id)
    end
    
    def create_loan_product
      loan_product = find_cooperative.loan_products.create!(
        name: name,
        description: description,
        maximum_loanable_amount: maximum_loanable_amount,
        current_account_id: current_account_id,
        past_due_account_id: past_due_account_id,
        amortization_type_id: amortization_type_id,

        loan_protection_plan_provider_id: loan_protection_plan_provider_id,
        grace_period: grace_period)

      loan_product.interest_configs.create(
        rate: interest_rate,
        calculation_type: interest_calculation_type,
        interest_revenue_account_id: interest_revenue_account_id,
        unearned_interest_income_account_id: unearned_interest_income_account_id)

      loan_product.penalty_configs.create(
        rate: penalty_rate,
        penalty_revenue_account_id: penalty_revenue_account_id)

      loan_product.interest_predeductions.create(
        calculation_type: interest_prededuction_calculation_type,
        rate: prededucted_rate,
        amount: prededucted_amount,
        number_of_payments: prededucted_number_of_payments
      )
    end

  end
end
