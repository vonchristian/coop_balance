module LoansModule
	class PrincipalAmortizationSchedule < AmortizationSchedule
    def self.create_schedule_for(loan)
      loan.amortization_schedules.destroy_all
      if loan.monthly?
        create_monthly_amortization_schedule(loan)
      elsif loan.lumpsum?
        create_lumpsum_amortization_schedule(loan)
      elsif loan.quarterly?
        create_quarterly_amortization_schedule(loan)
      elsif loan.semi_annually?
        create_semi_annuall_amortization_schedule(loan)
      end
    end

    def self.starting_date(loan)
      if loan.disbursed?
        loan.disbursement_date
      else
        loan.application_date
      end
    end

    def self.create_monthly_amortization_schedule(loan)
      first_amortization = loan.amortization_schedules.create(date: starting_date(loan).next_month, principal: (loan.loan_amount/loan.term.to_i), interest: (loan.interest_on_loan_balance / loan.term.to_i))
      ActiveRecord::Base.transaction do
        (loan.term.to_i - 1).times do
          loan.amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date.next_month, principal: (loan.loan_amount/loan.term.to_i), interest: (loan.interest_on_loan_balance / loan.term.to_i))
        end
      end
    end
    def self.create_lumpsum_amortization_schedule(loan)
      loan.amortization_schedules.create(date: loan.starting_date(loan) + loan.term.to_i.months, principal: (loan.loan_amount), interest: loan.interest_on_loan_balance)
    end
    def self.create_quarterly_amortization_schedule(loan)
      first_amortization = loan.amortization_schedules.create(date: loan.starting_date(loan).next_quarter, principal: (loan.loan_amount / 4))
      ActiveRecord::Base.transaction do
        ((loan.term.to_i / 3) -1).times do
          loan.amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date.next_quarter, principal: (loan.loan_amount/4), interest: (loan.interest_on_loan_balance/4))
        end
      end
    end
    def self.create_semi_annuall_amortization_schedule(loan)
      first_amortization = loan.amortization_schedules.create(date: loan.starting_date(loan).next_quarter.next_quarter, principal: (loan.loan_amount / (loan.term.to_i/6)), interest: (loan.interest_on_loan_balance/(loan.term.to_i/6)))
        ActiveRecord::Base.transaction do
        ((loan.term.to_i / 6) -1).times do
          loan.amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date + 6.months, principal: (loan.loan_amount/ (loan.term.to_i/6)), interest: (loan.interest_on_loan_balance/(loan.term.to_i/6)))
        end
      end
    end
	end
end
