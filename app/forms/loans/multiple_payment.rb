
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
    validates  :cash_account_id, presence: true

    def create_payment_voucher!
      if valid?
        ActiveRecord::Base.transaction do
          create_cart_line_item
        end
      end
    end


    def find_loan
      find_office.loans.find(loan_id)
    end

    def schedule_id
      if amortization_schedule_id.present?
        amortization_schedule_id
      end
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
      create_total_cash_amount
    end

    def create_total_cash_amount
      voucher_amounts = find_cart.voucher_amounts.where(account: Employees::EmployeeCashAccount.cash_accounts)
      if voucher_amounts.present?
        voucher_amounts.destroy_all
        find_cart.voucher_amounts.debit.create!(
          recorder_id: employee_id,
          amount:      find_cart.voucher_amounts.sum(&:amount),
          account_id:     cash_account_id,
          cooperative: find_employee.cooperative

          )
      else
        find_cart.voucher_amounts.debit.create!(
          amount:      find_cart.voucher_amounts.sum(&:amount),
          account_id:     cash_account_id,
          cooperative: find_employee.cooperative,
          recorder_id: employee_id,

          )
      end
    end

    def create_interest_revenue_amount
      if interest_amount.to_f > 0
        find_cart.voucher_amounts.credit.create!(
        amount:              BigDecimal(interest_amount),
        account:             find_loan.interest_revenue_account,
        commercial_document: find_loan,
        recorder:            find_employee,
        cooperative:         find_employee.cooperative)
      end
    end

    def create_penalty_amount
      if penalty_amount.to_f > 0
        find_cart.voucher_amounts.credit.create!(
        amount:              BigDecimal(penalty_amount),
        account:             find_loan.penalty_revenue_account,
        commercial_document: find_loan,
        recorder:    find_employee,
        cooperative: find_employee.cooperative)
      end
    end

    def create_principal_amount
      if principal_amount.to_f > 0
        find_cart.voucher_amounts.credit.create!(
        amount:      BigDecimal(principal_amount),
        account:     find_loan.receivable_account,
        commercial_document: find_loan,
        recorder:    find_employee,
        cooperative: find_employee.cooperative)
      end
    end

    def find_cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def total_amount
      principal_amount.to_f +
      interest_amount.to_f +
      penalty_amount.to_f
    end

    def principal_amount_not_more_than_balance
      errors[:principal_amount] << "Must be less than or equal to balance." if principal_amount.to_f > find_loan.balance
    end


  end
end
