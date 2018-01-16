class LoansQuery
  attr_reader :relation

  def initialize(relation = LoansModule::Loan.all)
    @relation = relation
  end
  def disbursed
    relation.select{|a| a.disbursed? }
  end
end
