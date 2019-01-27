require 'rails_helper'

module LoansModule
  module Amortizers
    module RepaymentCalculators
      describe EqualPayment do
        it "#total_repayment" do
          amortization_type = create(:amortization_type, repayment_calculation_type: 'equal_payment')
          loan_product = create(:loan_product, amortization_type: amortization_type)
          interest_config = create(:interest_config, rate: 0.17, loan_product: loan_product)
          loan_application = create(:loan_application, loan_amount: 150_000, term: 24, mode_of_payment: 'monthly', loan_product: loan_product)

          expect(described_class.new(loan_application: loan_application).total_repayment).to eql 7_416.34
        end
      end
    end
  end
end
