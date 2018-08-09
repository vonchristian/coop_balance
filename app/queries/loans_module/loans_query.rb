module LoansModule
  class LoansQuery
    attr_reader :relation

    def initialize(relation = LoansModule::Loan.active)
      @relation = relation
    end

    def matured(options={})
      from_date = options[:from_date] || relation.order(application_date: :desc).first.disbursement_date
      to_date  = options[:to_date] || Date.today
      range    = DateRange.new(from_date: from_date, to_date: to_date)
      relation.joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
    end


    def past_due(options={})
     if options[:from_date] && options[:to_date]
        from_date = options[:from_date]
        to_date   = options[:to_date]
        range     = DateRange.new(from_date: from_date, to_date: to_date)
        self.where.not(disbursement_date: nil).
        joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
      else
        self.where.not(disbursement_date: nil).
        joins(:terms).where('terms.maturity_date < ?', Date.today)
      end
    end

    def disbursed(options={})
      if options[:from_date] && options[:to_date]
        from_date = options[:from_date]
        to_date   = options[:to_date]
        range     = DateRange.new(from_date: from_date, to_date: to_date)
        relation.where.not(disbursement_date: nil).
        where('disbursement_date' => range.start_date..range.end_date)
      else
        relation.where.not(disbursement_date: nil)
      end
    end
  end
end
