require 'rails_helper'

module LoansModule
  module PaymentProcessors
    describe AddOnInterest do
      it 'process!' do
        cash_account    = create(:asset, name: 'Cash on Hand')
        employee        = create(:teller)
        employee.cash_accounts << cash_account
        loan_product = create(:loan_product_with_interest_and_penalty_account)
        create(:loan, status: 'current_loan', loan_product: loan_product)
        account_number = SecureRandom.uuid
        described_class.new(
          principal_amount: Money.new(150_000),
          interest_amount: Money.new(40_000),
          penalty_amount: Money.new(10_000),
          cash_account_id: Employees::EmployeeCashAccount.cash_accounts.last.id,
          employee_id: employee.id,
          loan_id: LoansModule::Loan.last.id,
          account_number: account_number
        ).process!
        voucher = TreasuryModule::Voucher.find_by(account_number: account_number)
        expect(voucher.voucher_amounts.pluck(:amount_cents)).to include(150_000)
        expect(voucher.voucher_amounts.pluck(:amount_cents)).to include(40_000)
        expect(voucher.voucher_amounts.pluck(:amount_cents)).to include(10_000)
        expect(voucher.voucher_amounts.pluck(:amount_cents)).to include(200_000)

        expect(voucher.voucher_amounts.pluck(:account_id)).to include loan_product.current_account_id
        expect(voucher.voucher_amounts.pluck(:account_id)).to include loan_product.current_interest_config.interest_revenue_account_id
        expect(voucher.voucher_amounts.pluck(:account_id)).to include loan_product.current_penalty_config.penalty_revenue_account_id
        expect(voucher.voucher_amounts.pluck(:account_id)).to include cash_account.id
      end
    end
  end
end
