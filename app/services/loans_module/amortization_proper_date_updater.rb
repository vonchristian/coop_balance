module LoansModule
  class AmortizationProperDateUpdater
    def initialize(args)
      @amortization_schedules = args.fetch(:amortization_schedules)
    end
  end
end
