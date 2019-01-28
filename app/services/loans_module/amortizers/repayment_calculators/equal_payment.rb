module LoansModule
  module Amortizers
    module RepaymentCalculators
      class EqualPayment

        attr_reader :loan_amount, :monthly_interest_rate, :schedule_count

        def initialize(args={})
          @loan_application      = args[:loan_application]
          @loan_amount           = @loan_application.loan_amount.amount
          @loan_product          = @loan_application.loan_product
          @schedule_count        = @loan_application.schedule_count.to_f
          @monthly_interest_rate = @loan_product.current_interest_config.monthly_interest_rate
        end

        def total_repayment
          pmt(monthly_interest_rate, schedule_count, -loan_amount)
        end

        private
        def pmt(monthly_interest_rate, schedule_count, present_value, future_value=0, type=0)
          ((-present_value * pvif(monthly_interest_rate, schedule_count) - future_value) / ((1.0 + monthly_interest_rate * type) * fvifa(monthly_interest_rate, schedule_count)))
        end

        def pow1pm1(x, y)
          (x <= -1) ? ((1 + x) ** y) - 1 : Math.exp(y * Math.log(1.0 + x)) - 1
        end

        def fvifa(monthly_interest_rate, schedule_count)
          (monthly_interest_rate == 0) ? schedule_count : pow1pm1(monthly_interest_rate, schedule_count) / monthly_interest_rate
        end
        def pow1p(x, y)
          (x.abs > 0.5) ? ((1 + x) ** y) : Math.exp(y * Math.log(1.0 + x))
        end
        def pvif(rate, nper)
          pow1p(rate, nper)
        end
      end
    end
  end
end
