module LoansModule
  module PaymentAggregator

    attr_reader :from_date, :to_date
    def initialize(args)
      @loans = args.fetch(:loans)
      @from_date = args[:from_date]
    end

    def entries
      AccountingModule::Amount.where(commercial_document: loans)
    end

    def total_principal
    end

    def total_interest
    end

    def total_penalty
    end
  end
end
