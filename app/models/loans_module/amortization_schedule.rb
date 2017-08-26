module LoansModule
	class AmortizationSchedule < ApplicationRecord
	  belongs_to :amortizeable, polymorphic: true
	  def self.principal_for(schedule, loan)
	  	from_date = loan.amortization_schedules.order(:created_at => "ASC").first.date.strftime('%Y/%m/%d')
      to_date = schedule.date.strftime('%Y/%m/%d')
      loan.amortization_schedules.select { |a| (DateTime.parse(from_date)..DateTime.parse(to_date)).include?(a.date)}.sum(&:principal)
	  end

	  def self.create_schedule_for(loan)
	  	first_amortization = loan.amortization_schedules.create(date: loan.application_date.next_month, principal: (loan.loan_amount/loan.term.to_i), interest: 2000)
	  	ActiveRecord::Base.transaction do 
	  		(loan.term.to_i - 1).times do 
	  			loan.amortization_schedules.create(date: loan.amortization_schedules.order(created_at: :asc).last.date.next_month, principal: (loan.loan_amount/loan.term.to_i), interest: 2000)
	  		end
	  	end
	  end
	end
end