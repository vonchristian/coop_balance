class LoansQuery
  attr_reader :relation

  def initialize(relation = LoansModule::Loan.all)
    @relation = relation
  end


  def matured(options={})
    range = DateRange.new(start_date: options[:from_date], to_date: options[:to_date])
    relation.joins(:terms).where('terms.maturity_date' => range)
  end

  def disbursed(options={})
    relation.where.not(disbursement_date: nil)
  end


  def disbursed_on(options={})
    from_date = Date.today
    to_date   = Date.today
    range     = DateRange.new(start_date: from_date, to_date: to_date)
    where('disbursement_date' => range)
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
