module Vouchers
  class LoanApplicationVoucher
    attr_reader :loan_application

    def initialize(args)
      @loan_application = args.fecth(:loan_application)
    end

    def create_interest_on_loan_charge
      loan_application.voucher_amounts.credit.create(
        cooperative: loan_application.cooperative,
        description: 'Interest on Loan',
        amount: loan_application.prededucted_interest,
        account: interest_revenue_account
      )
    end
  end
end
