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
    :penalty_revenue_account_id,
    :loan_protection_plan_provider_id,
    :cooperative_id,
    :grace_period

    validates :name, :maximum_loanable_amount,
    :loans_receivable_current_account_id,
    :loans_receivable_past_due_account_id,
    :interest_rate,
    :interest_revenue_account_id,
    :unearned_interest_income_account_id,
    :penalty_rate,
    :penalty_revenue_account_id,
    :cooperative_id,
    :grace_period, presence: true

    validates :maximum_loanable_amount, :grace_period, :interest_rate, :penalty_rate, numericality: true

    def initialize(attr={})
      if !attr["id"].nil?
        @loan_product = LoansModule::LoanProduct.find(attr["id"])
        @current_coorerative = @loan_product.cooperative

        self.name = attr[:name].nil? ? @loan_product.name : attr[:name]
        self.description = attr[:description].nil? ? @loan_product.description : attr[:description]
        self.maximum_loanable_amount = attr[:maximum_loanable_amount].nil? ? @loan_product.maximum_loanable_amount : attr[:maximum_loanable_amount]
        self.grace_period = attr[:grace_period].nil? ? @loan_product.grace_period : attr[:grace_period]
        self.loans_receivable_current_account_id = attr[:loans_receivable_current_account_id].nil? ? @loan_product.loans_receivable_current_account_id : attr[:loans_receivable_current_account_id]
        self.loans_receivable_past_due_account_id = attr[:loans_receivable_past_due_account_id].nil? ? @loan_product.loans_receivable_past_due_account_id : attr[:loans_receivable_past_due_account_id]
       else
         super(attr)
       end
    end

    def register!
      if valid?
        ActiveRecord::Base.transaction do
          create_loan_product
        end
      end
    end

    def update!
      if valid?
        ActiveRecord::Base.transaction do
          update_loan_product
        end
      end
    end

    def create_loan_product
      loan_product = !current_cooperative.loan_products.create!(
        name: name,
        description: description,
        maximum_loanable_amount: maximum_loanable_amount,
        loans_receivable_current_account_id: loans_receivable_current_account_id,
        loans_receivable_past_due_account_id: loans_receivable_past_due_account_id,
        cooperative_id: cooperative_id,
        loan_protection_plan_provider_id: loan_protection_plan_provider_id,
        grace_period: grace_period)

      loan_product.interest_configs.create(
        rate: interest_rate,
        interest_revenue_account_id: interest_revenue_account_id,
        unearned_interest_income_account_id: unearned_interest_income_account_id)

      loan_product.penalty_configs.create(
        rate: penalty_rate,
        penalty_revenue_account_id: penalty_revenue_account_id)
    end

    def update_loan_product
      @loan_product.update!(
        name: name,
        description: description,
        maximum_loanable_amount: maximum_loanable_amount,
        loans_receivable_current_account_id: loans_receivable_current_account_id,
        loans_receivable_past_due_account_id: loans_receivable_past_due_account_id,
        cooperative_id: cooperative_id,
        loan_protection_plan_provider_id: loan_protection_plan_provider_id,
        grace_period: grace_period)
    end
  end
end
