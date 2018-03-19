class BirthdayQuery
  attr_reader :relation
  def initialize(relation)
    @relation = relation
  end
  def has_birthdays_on(month)
    relation.where(birth_month: month).order(:birth_day)
  end
end
