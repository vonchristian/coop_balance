class EntriesQuery
  attr_reader :relation

  def initialize(relation = AccountingModule::Entry.all)
    @relation = relation
  end
  def entered_on(hash={})
    if hash[:from_date] && hash[:to_date]
      date_range = DateRange.new(from_date: hash[:from_date], to_date: hash[:to_date])
      relation.includes([:amounts]).where('entry_date' => (date_range.range))
    else
      relation.all
    end
  end
end
