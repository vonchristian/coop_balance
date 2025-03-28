module LoansModule
  class AmortizationSchedule < ApplicationRecord
    enum :payment_status, { full_payment: 0, partial_payment: 1, unpaid: 2 }
    belongs_to :loan,             optional: true
    belongs_to :loan_application, optional: true
    belongs_to :office,           class_name: "Cooperatives::Office"
    has_many :payment_notices,    as: :notified
    has_many :notes,              as: :noteable

    delegate :borrower, :loan_product_name, to: :loan
    delegate :avatar, :name, :current_contact_number, :current_address_complete_address, to: :borrower, prefix: true
    ###########################

    validates :date, :principal, :interest, presence: true
    validates :principal, :interest, numericality: true

    def self.total_principal(args = {})
      from_date = args[:from_date]
      to_date   = args[:to_date]

      if from_date && to_date
        scheduled_for(from_date: from_date, to_date: to_date).sum(&:principal)
      else
        sum(:principal)
      end
    end

    def payment_entries
      AccountingModule::Entry.where(id: entry_ids)
    end

    def total_payments
      payment_entries.sum { |e| e.debit_amounts.total }
    end

    def self.total_repayment
      sum(&:total_payments)
    end

    # for loan payment collection_select
    def date_schedule
      date.strftime("%B, %Y")
    end

    def self.partial_and_no_payment
      where.not(payment_status: "full_payment").or(no_payment)
    end

    def self.no_payment
      where(payment_status: nil)
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

    def self.not_cancelled
      select { |a| a.loan.not_cancelled? }
    end

    def self.total_principal_balance(args = {})
      to_date   = args.fetch(:to_date)
      from_date = args.fetch(:from_date)
      scheduled_for(from_date: from_date, to_date: to_date).sum(&:principal)
    end

    def self.total_interest_for(args = {})
      to_date   = args[:to_date]
      from_date = args[:from_date]
      if from_date && to_date
        scheduled_for(from_date: from_date, to_date: to_date).sum(&:interest)
      else
        sum(&:interest)
      end
    end

    def self.principal_for(args = {})
      schedule  = args.fetch(:schedule)
      from_date = oldest.date
      to_date   = schedule.date
      select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.sum(&:principal)
    end

    def self.total_amortization_for(args = {})
      schedule  = args.fetch(:schedule)
      from_date = oldest.date
      to_date   = schedule.date
      select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.sum(&:total_repayment)
    end

    def self.total_amortization(args = {})
      scheduled_for(args).sum(&:total_amortization)
    end

    def self.scheduled_for(args = {})
      from_date  = args.fetch(:from_date)
      to_date    = args.fetch(:to_date)
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      where("date" => date_range.range)
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
      to_date   = date
      count     = self.class.count { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }
      self.class.by_oldest_date.take(count - 1).last
    end

    def with_in_first_year?
      loan_application.amortization_schedules.order(date: :asc).first(12).include?(self)
    end

    def with_in_second_year?
      return false if loan_application.amortization_schedules.size <= 12

      loan_application.amortization_schedules.order(date: :asc).first(24).last(12).include?(self)
    end

    def with_in_third_year?
      return false if loan_application.amortization_schedules.size <= 24

      loan_application.amortization_schedules.order(date: :asc).first(36).last(12).include?(self)
    end

    def with_in_fourth_year?
      return false if loan_application.amortization_schedules.size <= 36

      loan_application.amortization_schedules.order(date: :asc).first(48).last(12).include?(self)
    end

    def with_in_fifth_year?
      return false if loan_application.amortization_schedules.size <= 48

      loan_application.amortization_schedules.order(date: :asc).first(60).last(12).include?(self)
    end
  end
end
