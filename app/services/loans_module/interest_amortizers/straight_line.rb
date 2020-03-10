module LoansModule
  module InterestAmortizers 
    class StraightLine
      attr_reader :schedule, :loan_application, :loan_product

      def initialize(schedule:)
        @schedule         = schedule
        @loan_application = @schedule.loan_application
        @loan_product     = @loan_application.loan_product
      end 

      def amortized_interest 
        return loan_application.total_interest if loan_application.lumpsum?

        applicable_total_interest / 12 
      end 

      def applicable_total_interest
        if schedule.with_in_first_year?
          loan_application.first_year_interest
        elsif schedule.with_in_second_year?
          loan_application.second_year_interest
        elsif schedule.with_in_third_year?
          loan_application.third_year_interest
        elsif schedule.with_in_fourth_year?
          loan_application.fourth_year_interest
        elsif schedule.with_in_fifth_year?
          loan_application.fifth_year_interest
        else 
          0
        end 
      end 

      def schedule_is_prededucted?
        loan_product.current_interest_prededuction.present? &&
        loan_product.current_interest_prededuction.number_of_payments_based? &&
        loan_application.amortization_schedules.order(date: :asc).first(loan_product.current_interest_prededuction.number_of_payments.to_i).include?(schedule)
      end 
      
    end 
  end 
end 