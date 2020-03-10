module LoansModule
  class PredeductedInterestUpdater 
    attr_reader :schedule, :loan_product, :loan_application
    def initialize(schedule:)
      @schedule = schedule
      @loan_application = @schedule.loan_application
      @loan_product = @loan_application.loan_product
    end 
    def update_prededucted_interests!
      if schedule_is_prededucted?
        schedule.update(prededucted_interest: true)
      end 

      if schedule_is_percent_based?
        schedule.update(prededucted_interest: true)
      end 
    end 

    def schedule_is_prededucted?
      loan_product.current_interest_prededuction.present? &&
      loan_product.current_interest_prededuction.number_of_payments_based? &&
      loan_application.amortization_schedules.order(date: :asc).first(loan_product.current_interest_prededuction.number_of_payments.to_i).include?(schedule)
    end 
    
    def schedule_is_percent_based?
      loan_application.lumpsum? && 
      loan_product.current_interest_prededuction.present? &&
      loan_product.current_interest_prededuction.percent_based? &&
      loan_product.current_interest_prededuction.rate == 1.0 
    end 
  end 
end 