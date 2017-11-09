module LoansModule
	class PrincipalAmortizationSchedule < AmortizationSchedule
    def self.create_schedule_for(loan)
      if loan.monthly?
        create_monthly_amortization_schedule(loan)
      elsif loan.lumpsum?
        first_amortization = loan.amortization_schedules.create(date: loan.application_date + loan.term.to_i.months, principal: (loan.loan_amount), interest: loan.interest_on_loan)
      elsif loan.quarterly?
        first_amortization = loan.amortization_schedules.create(date: loan.application_date.next_quarter, principal: (loan.loan_amount / 4))
        ActiveRecord::Base.transaction do
          ((loan.term.to_i / 3) -1).times do
            loan.amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date.next_quarter, principal: (loan.loan_amount/4))
          end
        end
      elsif loan.semi_annually?
        first_amortization = loan.amortization_schedules.create(date: loan.application_date.next_quarter.next_quarter, principal: (loan.loan_amount / 2))
        second_amortization = loan.amortization_schedules.create(date: loan.principal_amortization_schedules.last.date.next_quarter.next_quarter, principal: (loan.loan_amount / 2))
      end
    end

    def self.create_monthly_amortization_schedule(loan)
      first_amortization = loan.amortization_schedules.create(date: loan.application_date.next_month, principal: (loan.loan_amount/loan.term.to_i))
      ActiveRecord::Base.transaction do
        (loan.term.to_i - 1).times do
          loan.amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date.next_month, principal: (loan.loan_amount/loan.term.to_i))
        end
      end
    end
	end
end
