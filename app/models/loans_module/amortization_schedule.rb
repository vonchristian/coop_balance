module LoansModule
	class AmortizationSchedule < ApplicationRecord
	  belongs_to :amortizeable, polymorphic: true
    belongs_to :loan
    has_one :payment_notice, as: :notified
    enum schedule_type: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]
    # after_commit :create_payment_notice
    has_many :loan_charge_payment_schedules
    def self.scheduled_for(from_date, to_date)
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

    private
    def create_payment_notice
      PaymentNotice.create(notified: self, date: (self.date - 3.days), title: 'Payment Notice', content: 'Payment Notice')
    end
	end
end
