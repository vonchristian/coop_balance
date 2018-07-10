class BirthdayQuery
  attr_reader :relation
  def initialize(relation)
    @relation = relation
  end
  def has_birth_month_on(options={})
    relation.where(birth_month: options[:birth_month])
  end

  def has_birth_day_on(options={})
    relation.where(birth_day: options[:birth_day])
  end
end
