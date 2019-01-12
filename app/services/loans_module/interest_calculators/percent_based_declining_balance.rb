module LoansModule
  module InterestAmortizationCalculators
    class PercentBasedDecliningBalance

      def compute(date)
        loan_application.amortization_schedules.principal_balance(to_date: date) * rate
      end
    end
  end
end
