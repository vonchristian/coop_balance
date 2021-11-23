module LoansModule
  class TermUpdater
    attr_reader :loan, :effectivity_date
    def initialize(args={})
      @loan = args.fetch(:loan)
      @effectivity_date = args.fetch(:effectivity_date)
    end

    def update_term
      @loan.terms.recent.update(
        effectivity_date: effectivity_date,
        maturity_date:    effectivity_date + number_of_months
      )
    end
  end
end
