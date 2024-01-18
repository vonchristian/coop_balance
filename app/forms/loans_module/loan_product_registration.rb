module LoansModule
  class LoanProductRegistration
    include ActiveModel::Model
    attr_accessor :name, :id,
                  :office_id,
                  :description,
                  :maximum_loanable_amount,
                  :interest_rate,
                  :penalty_rate,
                  :loan_protection_plan_provider_id,
                  :cooperative_id,
                  :grace_period,
                  :amortization_type_id,
                  :interest_amortization_id,
                  :total_repayment_amortization_id,
                  :interest_calculation_type,
                  :prededuction_calculation_type,
                  :prededuction_scope,
                  :prededucted_rate,
                  :prededucted_amount,
                  :prededucted_number_of_payments

    validates :name, :maximum_loanable_amount,
              :interest_rate,
              :penalty_rate,
              :cooperative_id,
              :prededuction_calculation_type,
              :prededuction_scope,
              :prededucted_rate,
              :prededucted_number_of_payments,
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
        office_id: office_id,
        name: name,
        description: description,
        maximum_loanable_amount: maximum_loanable_amount,
        interest_amortization_id: interest_amortization_id,
        total_repayment_amortization_id: total_repayment_amortization_id,

        amortization_type_id: amortization_type_id,
        loan_protection_plan_provider_id: loan_protection_plan_provider_id,
        grace_period: grace_period
      )

      create_interest_config(loan_product)
      create_penalty_config(loan_product)
    end

    def create_interest_config(loan_product)
      loan_product.interest_configs.create!(
        rate: interest_rate,
        calculation_type: interest_calculation_type
      )
    end

    def create_penalty_config(loan_product)
      loan_product.penalty_configs.create!(rate: penalty_rate)
    end
  end
end
