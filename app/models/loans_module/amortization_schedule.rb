module LoansModule
	class AmortizationSchedule < ApplicationRecord
    belongs_to :loan
    has_many :payment_notices, as: :notified
    has_many :notes, as: :noteable

    accepts_nested_attributes_for :notes
    def self.create_schedule_for(loan)
      loan.amortization_schedules.destroy_all
      if loan.monthly? || loan.quarterly? || loan.semi_annually?
        create_amort_schedule(loan)
      elsif loan.lumpsum?
        create_lumpsum_amortization_schedule(loan)
      end
    end

    def self.starting_date(loan)
      if loan.disbursed?
        loan.disbursement_date
      else
        loan.application_date
      end
    end

    def self.create_amort_schedule(loan)
      first_amortization = loan.amortization_schedules.create(
				date: first_amortization_date_for(loan),
				principal: principal_amount_for(loan),
				interest:interest_amount_for(loan)
			)
      ActiveRecord::Base.transaction do
        number_of_schedules_for(loan).times do
          loan.amortization_schedules.create(
						date: schedule_date_for(loan),
						principal: principal_amount_for(loan),
						interest: interest_amount_for(loan)
					)
        end
      end
    end

    def self.create_lumpsum_amortization_schedule(loan)
      loan.amortization_schedules.create(
				date: starting_date(loan) + loan.term.to_i.months,
				principal: (loan.loan_amount), interest:
				loan.interest_on_loan_balance)
    end

    def self.for(options={})
      if options[:from_date].present? && options[:to_date].present?
        where('date' => (options[:from_date].beginning_of_day)..(options[:to_date].end_of_day))
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

		def self.principal_amount_for(loan)
			if loan.quarterly?
			  (loan.loan_amount / (loan.term / 4))
			elsif loan.monthly?
				(loan.loan_amount / loan.term.to_i)
			elsif loan.semi_annually?
				(loan.loan_amount / (loan.term.to_i/6))
			end
		end

		def self.interest_amount_for(loan)
			if loan.monthly?
				(loan.interest_on_loan_balance / (loan.term))
		  elsif loan.quarterly?
			  (loan.interest_on_loan_balance / (loan.term/4))
			elsif loan.semi_annually?
				(loan.interest_on_loan_balance/(loan.term.to_i/6))
			end
		end

		def self.number_of_schedules_for(loan)
			if loan.quarterly?
			  ((loan.term.to_i / 4) -1)
		  elsif loan.monthly?
			  (loan.term.to_i - 1)
			elsif loan.semi_annually?
				((loan.term.to_i / 6) -1)
      end
		end

		def self.schedule_date_for(loan)
			if loan.monthly?
			  loan.amortization_schedules.order(created_at: :asc).last.date.next_month
			elsif loan.quarterly?
				loan.amortization_schedules.order(created_at: :asc).last.date.next_quarter
			elsif loan.semi_annually?
				loan.amortization_schedules.order(created_at: :asc).last.date + 6.months
			end
		end
		def self.first_amortization_date_for(loan)
			if loan.monthly?
			  starting_date(loan).next_month
			elsif loan.quarterly?
				starting_date(loan).next_quarter
			elsif loan.semi_annually?
				starting_date(loan).next_quarter.next_quarter
			end
		end
	end
end
