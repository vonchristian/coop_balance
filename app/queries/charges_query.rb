class ChargesQuery
  attr_reader :relation

  def initialize(relation = Charge.all)
    @relation = relation
  end

  def depends_on_loan_amount
    relation.where(depends_on_loan_amount: true)
  end

	def not_depends_on_loan_amount
    relation.where(depends_on_loan_amount: false)
  end
end
