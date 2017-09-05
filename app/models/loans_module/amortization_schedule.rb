module LoansModule
	class AmortizationSchedule < ApplicationRecord
	  belongs_to :amortizeable, polymorphic: true
	  def self.principal_for(schedule, loan)
	  	from_date = loan.amortization_schedules.order(:created_at => "ASC").first.date.strftime('%Y/%m/%d')
      to_date = schedule.date.strftime('%Y/%m/%d')
      loan.amortization_schedules.select { |a| (DateTime.parse(from_date)..DateTime.parse(to_date)).include?(a.date)}.sum(&:principal)
	  end
    def total_amortization
      principal + interest
    end
	end
end