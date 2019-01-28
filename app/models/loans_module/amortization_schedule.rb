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

    validates :date, :principal, :interest, presence: true
    validates :principal, :interest, numericality: true

    def self.total_principal(args={})
      from_date = args[:from_date]
      to_date   = args[:to_date]

      if from_date && to_date
        scheduled_for(from_date: from_date, to_date: to_date).sum(&:principal)
      else
        sum(:principal)
      end
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

    def self.total_principal_balance(args={})
      to_date   = args.fetch(:to_date)
      from_date = args.fetch(:from_date)
      scheduled_for(from_date: from_date, to_date: to_date).sum(&:principal)
    end

    def self.total_interest(args={})
      to_date   = args[:to_date]
      from_date = args[:from_date]
      if from_date && to_date
        scheduled_for(from_date: from_date, to_date: to_date).sum(&:interest)
      else
        sum(&:interest)
      end
    end

    def self.principal_for(args={})
      schedule  = args.fetch(:schedule)
      from_date = oldest.date
      to_date   = schedule.date
      select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.sum(&:principal)
    end

    def self.total_amortization_for(args={})
      schedule  = args.fetch(:schedule)
      from_date = oldest.date
      to_date   = schedule.date
      select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.sum(&:total_repayment)
    end

    def self.scheduled_for(args={})
      from_date  = args.fetch(:from_date)
      to_date    = args.fetch(:to_date)
			date_range = DateRange.new(from_date: from_date, to_date: to_date)
      where('date' => date_range.range)
    end


    def total_amortization
       principal +
       interest_computation
    end

    def interest_computation
      if prededucted_interest?
        0
      else
        interest
      end
    end

    def previous_schedule
      from_date = self.class.oldest.date
      to_date   = self.date
      count     = self.class.select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.count
      self.class.by_oldest_date.take(count-1).last
    end
	end
end
