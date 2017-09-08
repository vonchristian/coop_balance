module LoansModule
	class AmortizationSchedule < ApplicationRecord
	  belongs_to :amortizeable, polymorphic: true
    def self.for(from_date, to_date)
      if from_date && to_date
        where('date' => from_date..to_date)
      end
    end
	  def self.principal_for(schedule, loan)
	  	from_date = loan.amortization_schedules.order(created_at: :asc).first.date
      to_date = schedule.date
      loan.amortization_schedules.select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date)}.sum(&:principal)
	  end
    def total_amortization
      principal + interest
    end
	end
end