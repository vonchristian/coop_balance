require 'rails_helper'

module LoansModule
  module InterestPredeductionCalculators
    describe NumberOfPaymentsCalculator do
      it "#compute" do
        loan_product = create(:loan_product)
        interest_prededuction = create(:interest_prededuction, number_of_payments: 3, loan_product: loan_product)
        loan_application = create(:loan_application, loan_product: loan_product)

        LoansModule::AmortizationScheduler.new(loan_application: loan_application).create_schedule!

        expect(described_class.new(loan_application: loan_application, interest_prededuction: interest_prededuction).compute).to eql loan_application.amortization_schedules.order(date: :desc).first(3).total_amortization

      end
    end
  end
end
