module LoansModule
	class AmortizationSchedule < ApplicationRecord
    enum payment_status: [:full_payment, :partial_payment, :unpaid]
    belongs_to :loan
    belongs_to :loan_application
    belongs_to :cooperative
    has_many :payment_notices, as: :notified
    has_many :notes, as: :noteable

    delegate :borrower, :loan_product_name, to: :loan
    delegate :avatar, :name, :current_contact_number, :current_address_complete_address, to: :borrower, prefix: true
    ###########################

    validates :date, :principal, presence: true

    def self.total_principal
      sum(:principal)
    end

    def self.total_interest
      sum(:interest)
    end

    def self.latest
      order(date: :asc).last
    end

    def self.oldest
      order(date: :asc).first
    end

    def self.by_oldest_date
      order(date: :asc)
    end

    def self.for_loans
      where.not(loan_id: nil)
    end

    def self.total_principal_balance(args)
      to_date   = args[:to_date]
      from_date = args[:from_date]
      scheduled_for(from_date: from_date, to_date: to_date).sum(&:principal)
    end

    def self.principal_for(args={})
      schedule  = args.fetch(:schedule)
      from_date = oldest.date
      to_date   = schedule.date
      select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.sum(&:principal)
    end

    def self.scheduled_for(args={})
			if args[:from_date] && args[:to_date]
				date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
        where('date' => date_range.range)
      end
    end


    def total_amortization
       principal +
       interest
    end
	end
end
