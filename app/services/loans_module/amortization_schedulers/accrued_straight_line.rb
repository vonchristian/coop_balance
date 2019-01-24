module LoansModule
  module AmortizationSchedulers
    class AccruedStraightLine
      attr_reader :scheduleable, :loan_product

      def initialize(args)
        @scheduleable = args.fetch(:scheduleable)
        @loan_product = @scheduleable.loan_product
      end

      def create_schedule!
        create_first_schedule
        create_succeeding_schedule
      end


      private
      def create_first_schedule
        scheduleable.amortization_schedules.create!(
          date:      scheduleable.first_amortization_date,
          interest:  0,
          principal: scheduleable.amortizeable_principal
        )
      end

      def create_succeeding_schedule
        if !scheduleable.lumpsum?
          (scheduleable.schedule_count - 1).floor.times do
            scheduleable.amortization_schedules.create!(
              date:      scheduleable.succeeding_amortization_date,
              interest:  0,
              principal: scheduleable.amortizeable_principal
            )
          end
        end
      end
    end
  end
end
