module LoansModule
  class LoanProductRegistration
    include ActiveModel::Model
    attr_accessor :name,
    :description,
    :maximum_loanable_amount,
    :loans_receivable_current_account_id,
    :loans_receivable_past_due_account_id,
    :interest_rate,
    :interest_revenue_account_id,
    :unearned_interest_income_account_id,
    :penalty_rate,
    :penalty_revenue_account_id

    validates :name, :maximum_loanable_amount,
    :loans_receivable_current_account_id,
    :loans_receivable_past_due_account_id,
    :interest_rate,
    :interest_revenue_account_id,
    :unearned_interest_income_account_id,
    :penalty_rate,
    :penalty_revenue_account_id, presence: true

    validates :maximum_loanable_amount, :interest_rate, :penalty_rate, numericality: true

    def register!
      create_loan_product
    end
    private
    def create_loan_product
      loan_product = LoansModule::LoanProduct.create!(
        name: name,
        description: description,
        maximum_loanable_amount: maximum_loanable_amount,
        loans_receivable_current_account_id: loans_receivable_current_account_id,
        loans_receivable_past_due_account_id: loans_receivable_past_due_account_id,
        )
      loan_product.interest_configs.create(
        rate: interest_rate,
        interest_revenue_account_id: interest_revenue_account_id,
        unearned_interest_income_account_id: unearned_interest_income_account_id)
      loan_product.penalty_configs.create(
        rate: penalty_rate,
        penalty_revenue_account_id: penalty_revenue_account_id)
    end
  end
end


