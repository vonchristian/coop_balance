module LoansModule
  module LoanProducts
    class PredeductedInterestConfig < LoansModule::LoanProducts::InterestConfig

      def compute_interest(loan_application)
        if monthly_rate?
          ((loan_application.balance * loan_application.monthly_rate) * term).to_f
        else
          ((loan_application.balance * rate)).to_f
        end
      end

      def compute_prededucted_interest(loan_application)
        compute_interest(loan_application) * prededucted_rate
      end
    end
  end
end
