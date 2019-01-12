require 'rails_helper'

module LoansModule
  module InterestConfigs
    describe PredeductedInterestConfig do
      it "#prededucted_interest(loan_application)" do
        loan_product = create(:loan_product, interest_type: 'prededucted')
        interest_config = create(:interest_config, annual_rate: 0.12)
        loan_application = create(:loan_application, loan_product: loan_product, loan_amount: 100_000)

        expect(described_class.prededucted_interest(loan_application))
      end
    end
  end
end
