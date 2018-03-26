module LoansModule
  class LoansQuery
    attr_reader :relation

    def initialize(relation = LoansModule::Loan.all)
      @relation = relation
    end

    def matured(options={})
      from_date = options[:from_date] || relation.order(application_date: :desc).first.disbursement_date
      to_date  = options[:to_date] || Date.today
      range    = DateRange.new(from_date: from_date, to_date: to_date)
      relation.where('maturity_date' => range.start_date..range.end_date )
    end

    def past_due(options={})
      from_date = options[:from_date] || relation.order(application_date: :desc).first.disbursement_date
      to_date   = options[:to_date] || Date.today
      range     = DateRange.new(from_date: from_date, to_date: to_date)
      relation.where('maturity_date' => range.start_date..range.end_date )
    end

    def disbursed(options={})
      from_date = options[:from_date] || relation.order(application_date: :desc).first.disbursement_date
      to_date   = options[:to_date] || Date.today
      range     = DateRange.new(from_date: from_date, to_date: to_date)
      relation.where.not(disbursement_date: nil).
      where('disbursement_date' => range.start_date..range.end_date)
    end

    def aging(options={})
      aging_loans = []
      range = options[:min]..options[:max]
      relation.past_due.each do |loan|
        if range.include?(loan.number_of_days_past_due)
          aging_loans << loan
        end
      end
      aging_loans
    end
  end
end
