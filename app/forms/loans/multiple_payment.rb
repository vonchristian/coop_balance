module Loans
  class MultiplePayment
    include ActiveModel::Model
    attr_accessor :loan_id,
                  :principal_amount,
                  :interest_amount,
                  :penalty_amount,
                  :amortization_schedule_id,
                  :employee_id,
                  :cash_account_id,
                  :cart_id

    validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

    def process!
      return unless valid?

      ActiveRecord::Base.transaction do
        create_cart_line_item
      end
    end

    def find_loan
      find_office.loans.find(loan_id)
    end

    def schedule_id
      return if amortization_schedule_id.blank?

      amortization_schedule_id
    end

    def find_employee
      User.find(employee_id)
    end

    def find_office
      find_employee.office
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end

    private

    def create_cart_line_item
      create_penalty_amount
      create_principal_amount
      create_interest_revenue_amount
    end

    def create_interest_revenue_amount
      return unless interest_amount.to_f.positive?

      find_cart.voucher_amounts.credit.create!(
        amount: BigDecimal(interest_amount),
        account: find_loan.interest_revenue_account,
        recorder: find_employee,
        cooperative: find_employee.cooperative
      )
    end

    def create_penalty_amount
      return unless penalty_amount.to_f.positive?

      find_cart.voucher_amounts.credit.create!(
        amount: BigDecimal(penalty_amount),
        account: find_loan.penalty_revenue_account,
        recorder: find_employee,
        cooperative: find_employee.cooperative
      )
    end

    def create_principal_amount
      return unless principal_amount.to_f.positive?

      find_cart.voucher_amounts.credit.create!(
        amount: BigDecimal(principal_amount),
        account: find_loan.receivable_account,
        recorder: find_employee,
        cooperative: find_employee.cooperative
      )
    end

    def principal_amount_not_more_than_balance
      errors[:principal_amount] << 'Must be less than or equal to balance.' if principal_amount.to_f > find_loan.balance
    end
  end
end
