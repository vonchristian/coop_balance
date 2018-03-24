module LoansModule
  class PastDueLoansQuery
    attr_reader :relation

    def initialize(relation = LoansModule::Loan.past_due)
      @relation = relation
    end
    def past_due(options={})
      if options[:min] && options[:max]
      range = options[:min]..options[:max]
      loans = []
        relation.each do |loan|
          if range.include?(loan.number_of_days_past_due)
            loans << loan
          end
        end
        loans
      end
    end
  end
end
