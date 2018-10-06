module LoansModule
  class LoansQuery
    attr_reader :relation

    def initialize(relation = LoansModule::Loan.active)
      @relation = relation
    end

    def matured(args={})
      from_date = args[:from_date] || relation.order(application_date: :desc).first.disbursement_date
      to_date  = args[:to_date] || Date.today
      range    = DateRange.new(from_date: from_date, to_date: to_date)
      relation.joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
    end


    def past_due(args={})
     if args[:from_date] && args[:to_date]
        from_date = args[:from_date]
        to_date   = args[:to_date]
        range     = DateRange.new(from_date: from_date, to_date: to_date)
        self.where.not(disbursement_date: nil).
        joins(:terms).where('terms.maturity_date' => range.start_date..range.end_date )
      else
        self.where.not(disbursement_date: nil).
        joins(:terms).where('terms.maturity_date < ?', Date.today)
      end
    end

    def disbursed(args={})
      if args[:from_date] && args[:to_date]
        from_date = args[:from_date]
        to_date   = args[:to_date]
        range     = DateRange.new(from_date: from_date, to_date: to_date)
        relation.where.not(voucher_id: nil).
        joins(:voucher).merge(Voucher.disbursed).
        where('vouchers.date' => range.start_date..range.end_date)
      else
        joins(:voucher).merge(Voucher.disbursed)
      end
    end
  end
end
