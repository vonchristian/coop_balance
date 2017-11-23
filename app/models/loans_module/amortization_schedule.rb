module LoansModule
	class AmortizationSchedule < ApplicationRecord
	  belongs_to :amortizeable, polymorphic: true
    belongs_to :loan
    has_one :payment_notice, as: :notified
    enum schedule_type: [:daily, :weekly, :monthly, :semi_monthly, :quarterly, :semi_annually, :lumpsum]
    has_many :notes, as: :noteable
    accepts_nested_attributes_for :notes
    # after_commit :create_payment_notice
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

    def self.scheduled_for(options={})
      if options[:from_date] && options[:to_date]
        where('date' => (options[:from_date].beginning_of_day)..(options[:to_date]).end_of_day)
      end
    end
    def total_amortization(options = {})
       principal + interest +
       total_other_charges_for(self.date)
    end
    def total_other_charges_for(date)
      loan.loan_charge_payment_schedules.scheduled_for(date).sum(:amount)
    end

    private
    def create_payment_notice
      PaymentNotice.create(notified: self, date: (self.date - 3.days), title: 'Payment Notice', content: 'Payment Notice')
    end
	end
end
