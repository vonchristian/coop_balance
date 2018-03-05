module LoansModule
	class AmortizationSchedule < ApplicationRecord
    belongs_to :loan
    has_many :payment_notices, as: :notified
    has_many :notes, as: :noteable

    accepts_nested_attributes_for :notes

    def debit_account
      loan.loan_product.interest_revenue_account
    end
    def credit_account
      loan.loan_product.unearned_interest_income_account
    end
    def self.with_prededucted_interests
      select{|a| a.has_prededucted_interest? }
    end

		def self.create_schedule_for(loan)
      if loan.amortization_schedules.present?
        loan.amortization_schedules.destroy_all
      end
			create_first_schedule(loan)
      create_succeeding_schedule(loan)
      if loan.preparer_cooperative.tinoc?
        update_amortization_schedule(loan)
        update_with_prededucted_interest_payments(loan)
        LoansModule::PredeductedInterest.create_schedules_for(loan)
      end
    end
    def self.average_monthly_payment(loan)
      all.collect{ |a| a.total_amortization }.sum / loan.term
    end

    def self.principal_for(schedule, loan)
      from_date = loan.amortization_schedules.order(created_at: :asc).first.date
      to_date = schedule.date
      loan.amortization_schedules.select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date)}.sum(&:principal)
    end

    def self.scheduled_for(options={})
			if options[:from_date].present? && options[:to_date].present?
				date_range = DateRange.new(from_date options[:from_date], to_date: options[:to_date])
        where('date' => (date_range.start_date..date_range.end_date))
      end
    end

    def total_amortization(options = {})
       principal + interest_computation +
       total_other_charges_for(self.date)
    end

    def interest_computation #show on pdf amortization schedule
      if has_prededucted_interest?
        0
      else
        interest
      end
    end


    def total_other_charges_for(date)
      loan.loan_charge_payment_schedules.scheduled_for(date).sum(:amount)
    end

    def self.update_amortization_schedule(loan)
      loan.amortization_schedules.order(date: :asc).each do |amortization_schedule|
        amortization_schedule.interest = (loan.balance_for(amortization_schedule) * loan.loan_product_monthly_interest_rate)
        amortization_schedule.save
      end
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
					number_of_remaining_schedules_for(loan).times do
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
			(loan.loan_amount / number_of_payments(loan))
		end

		def self.interest_amount_for(loan)
      # loan.amortization_schedules.order(date: :asc).map{}
			(loan.interest_on_loan_balance / number_of_payments(loan))
		end

    def self.number_of_payments(loan)
      if loan.monthly?
        loan.term.to_i
      elsif loan.quarterly?
        loan.term.to_i / 4
      elsif loan.semi_annually?
        loan.term.to_i / 6
      elsif loan.lumpsum?
        1
      end
    end


		def self.number_of_remaining_schedules_for(loan)
			number_of_payments(loan) - 1
		end
		def self.schedule_date_for(loan)
			if loan.monthly?
			  month_date = loan.amortization_schedules.order(created_at: :asc).last.date.next_month
        proper_date_for(month_date)
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
    def self.update_with_prededucted_interest_payments(loan)
      if  loan.number_of_interest_payments_prededucted > 0
        loan.amortization_schedules.order(date: :asc).first(loan.number_of_interest_payments_prededucted).each do |schedule|
          schedule.has_prededucted_interest = true
          schedule.save
        end
      end
    end
    def self.proper_date_for(date)
      if date.sunday?
        date.to_date.next
      else
        date
      end
    end
	end
end
