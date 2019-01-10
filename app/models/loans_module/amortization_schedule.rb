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
    def self.for_loans
      where.not(loan_id: nil)
    end
    
    def self.principal_balance(args={})
      if args[:from_date] && args[:to_date]
        from_date = args[:from_date]
        to_date =  args[:to_date]
        scheduled_for(from_date: from_date, to_date: to_date).to_a.sum(&:principal)
      elsif args[:number_of_months]
        take(args[:number_of_months]).sum(&:principal)
      else
        sum(&:principal)
      end
    end

    def self.create_amort_schedule_for(loan_application)
      create_first_schedule(loan_application)
      create_succeeding_schedule(loan_application)
      set_interests(loan_application)
      set_proper_dates(loan_application)
    end

    def self.create_first_schedule(loan_application)
      loan_application.amortization_schedules.create!(
        cooperative: loan_application.cooperative,
        date: first_amortization_date_for(loan_application),
        principal: principal_amount_for(loan_application)
      )
    end

    def self.create_succeeding_schedule(loan_application)
      return false if loan_application.lumpsum?
      ActiveRecord::Base.transaction do
        number_of_remaining_schedules_for(loan_application).times do
          loan_application.amortization_schedules.create!(
            cooperative: loan_application.cooperative,
            date: schedule_date_for(loan_application),
            principal: principal_amount_for(loan_application)
          )
        end
      end
    end

    def self.set_interests(loan_application)
      loan_application.amortization_schedules.each do |schedule|
        schedule.update_attributes(
          interest: interest_computation(schedule, loan_application))
      end
      if loan_application.current_interest_config.prededucted? && loan_application.current_interest_config.number_of_payment?
        loan_application.amortization_schedules.order(date: :asc).first(loan_application.current_interest_config_prededucted_number_of_payments).each do |schedule|
          schedule.update_attributes!(prededucted_interest: true)
        end
      end
    end

    def self.set_proper_dates(loan_application)
      loan_application.amortization_schedules.each do |schedule|
        schedule.update_attributes(
          date: ProperDateFinder.new(date: schedule.date, operating_days: loan_application.cooperative.operating_days).proper_date)
      end
    end

    def self.interest_computation(schedule, loan_application)
      if loan_application.current_interest_config_straight_balance?
        straight_balance_interest_computation(schedule, loan_application)
      elsif loan_application.current_interest_config_annually?
        annual_interest_computation(loan_application)
      else
        0
      end
    end

    # def previous_schedule(loan_application)
    #   from_date = loan_application.amortization_schedules.order(date: :asc).first.date
    #   to_date = self.date
    #   count = loan_application.amortization_schedules.select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.count
    #   loan_application.amortization_schedules.order(date: :asc).take(count-1).last
    # end


    # def self.average_monthly_payment(loan)
    #   if loan.lumpsum?
    #     loan.loan_amount.amount
    #   else
    #     all.collect{ |a| a.total_amortization }.sum / loan.current_term_number_of_months
    #   end
    # end

    def self.principal_for(schedule, loan)
      from_date = loan.amortization_schedules.order(date: :asc).first.date
      to_date = schedule.date
      loan.amortization_schedules.select { |a| (from_date.beginning_of_day..to_date.end_of_day).cover?(a.date) }.sum(&:principal)
    end

    def self.scheduled_for(args={})
			if args[:from_date].present? && args[:to_date].present?
				date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
        where(date: date_range.start_date..date_range.end_date)
      end
    end

    def interest_computation
      if prededucted_interest?
        0
      else
        interest
      end
    end

    def total_amortization
       principal +
       interest_computation
    end




		private
    def self.straight_balance_interest_computation(schedule, loan)
      if loan.lumpsum?
        loan.loan_amount.amount * loan.loan_product_monthly_interest_rate * loan.term
      else
        (loan.principal_balance_for(schedule) * loan.loan_product_monthly_interest_rate)
      end
    end

    def self.annual_interest_computation(loan_application)
      if loan_application.lumpsum?
        loan_application.interest_balance
      else
        loan_application.interest_balance / loan_application.term
      end
    end

		def self.starting_date(loan)
      loan.application_date
    end

		def self.principal_amount_for(loan)
			(loan.loan_amount.amount / number_of_payments(loan))
		end


    def self.number_of_payments(loan)
      if loan.monthly?
        loan.term.to_i
      elsif loan.quarterly?
        loan.current_term_number_of_months.to_i / 4
      elsif loan.semi_annually?
        loan.current_term_number_of_months.to_i / 6
      elsif loan.lumpsum?
        1
      elsif loan.weekly?
        (loan.term * 4).to_i
      end
    end

		def self.number_of_remaining_schedules_for(loan)
			number_of_payments(loan) - 1
		end

		def self.schedule_date_for(loan)
			if loan.monthly?
			  month_date = loan.amortization_schedules.order(date: :asc).last.date.next_month
			elsif loan.quarterly?
				loan.amortization_schedules.order(date: :asc).last.date.next_quarter
			elsif loan.semi_annually?
				loan.amortization_schedules.order(date: :asc).last.date + 6.months
      elsif loan.lumpsum?
        loan.amortization_schedules.order(date: :asc).last.date + add_months + add_days
      elsif loan.weekly?
        loan.amortization_schedules.order(date: :asc).last.date.next_week
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
				starting_date(loan) + add_months(loan) + add_days(loan)
      elsif loan.weekly?
        starting_date(loan).next_month
			end
		end

    def self.add_months(loan)
      TermParser.new(term: loan.term.to_f).add_months
    end

    def self.add_days(loan)
      TermParser.new(term: loan.term.to_f).add_days
    end
	end
end
