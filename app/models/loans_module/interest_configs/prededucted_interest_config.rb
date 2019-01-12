module LoansModule
  module InterestConfigs
    class PredeductedInterestConfig < LoansModule::LoanProducts::InterestConfig

      # def predeductible_interest(loan_application)
      #   if monthly_rate?
      #     ((loan_application.loan_amount * loan_application.monthly_rate) * loan_application.term).to_f
      #   else
      #     ((loan_application.loan_amount * rate)).to_f
      #   end
      # end

      def prededucted_interest(loan_application)
        predeductible_interest(loan_application) * prededucted_rate
      end
    end
  end
end
