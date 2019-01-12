module LoansModule
  class AmortizationScheduler
    attr_reader :scheduleable

    def initialize(args)
      @scheduleable = args.fetch(:scheduleable)
    end

    def create_schedule!
      create_first_schedule
      if scheduleable.schedule_count > 1
        create_succeeding_schedule
      end
    end

    def create_first_schedule
      scheduleable.amortization_schedules.create(
        date:      scheduleable.first_amortization_date,
        interest:  0,
        principal: scheduleable.amortizeable_principal
      )
    end

    def create_succeeding_schedule
      (scheduleable.schedule_count - 1).to_i.times do
        scheduleable.amortization_schedules.create(
          date:      scheduleable.succeeding_amortization_date,
          interest:  0,
          principal: scheduleable.amortizeable_principal
        )
      end
    end
  end
end
