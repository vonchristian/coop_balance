class BirthdayQuery
  attr_reader :relation
  def initialize(relation)
    @relation = relation
  end
  def has_birth_month_on(birth_month:)
    relation.where(birth_month: birth_month)
  end

  def has_birth_day_on(birth_day:)
    relation.where(birth_day: birth_day)
  end
end
