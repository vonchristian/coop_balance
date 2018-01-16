module LoansModule
	class AmortizationSchedule < ApplicationRecord
    belongs_to :loan
    has_many :payment_notices, as: :notified
    has_many :notes, as: :noteable

    accepts_nested_attributes_for :notes

		def self.create_schedule_for(loan)
			create_first_schedule(loan)
      create_succeeding_schedule(loan)
    end

    def self.principal_for(schedule, loan)
      from_date = loan.amortization_schedules.order(created_at: :asc).first.date
      to_date = schedule.date
      loan.amortization_schedules.select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date)}.sum(&:principal)
    end

    def self.scheduled_for(options={})
			if options[:from_date].present? && options[:to_date].present?
				from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : Chronic.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
         to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : Chronic.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        where('date' => (from_date.beginning_of_day)..(to_date.end_of_day))
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
		def self.starting_date(loan)
      if loan.disbursed?
        loan.disbursement_date
      else
        loan.application_date
      end
    end

		def self.create_first_schedule(loan)
			first_amortization = loan.amortization_schedules.create(
				date: first_amortization_date_for(loan),
				principal: principal_amount_for(loan),
				interest:interest_amount_for(loan)
			)
		end

		def self.create_succeeding_schedule(loan)
			if !loan.lumpsum?
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
		end
		def self.principal_amount_for(loan)
			if loan.quarterly?
			  (loan.loan_amount / (loan.term / 4))
			elsif loan.monthly?
				(loan.loan_amount / loan.term.to_i)
			elsif loan.semi_annually?
				(loan.loan_amount / (loan.term.to_i/6))
			elsif loan.lumpsum?
				(loan.loan_amount)
			end
		end

		def self.interest_amount_for(loan)
			if loan.monthly?
				(loan.interest_on_loan_balance / (loan.term))
		  elsif loan.quarterly?
			  (loan.interest_on_loan_balance / (loan.term/4))
			elsif loan.semi_annually?
				(loan.interest_on_loan_balance/(loan.term.to_i/6))
			elsif loan.lumpsum?
				loan.interest_on_loan_balance
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
			elsif loan.lumpsum?
				starting_date(loan) + loan.term.to_i.months
			end
		end
	end
end
