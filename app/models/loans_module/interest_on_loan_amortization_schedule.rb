module LoansModule 
	class InterestOnLoanAmortizationSchedule < AmortizationSchedule
    def self.create_schedule_for(loan)
      first_amortization = loan.interest_on_loan_amortization_schedules.create(date: loan.application_date.next_month, principal: (loan.loan_amount/loan.term.to_i), interest: nil)
      ActiveRecord::Base.transaction do 
        (loan.term.to_i - 1).times do 
          loan.interest_on_loan_amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date.next_month, principal: (loan.loan_amount/loan.term.to_i), interest: 2000)
        end
      end
    end
	end
end