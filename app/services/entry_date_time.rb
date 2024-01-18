EntryDateTime = Struct.new(:entry, keyword_init: true) do
  def set
    Time.zone.local(
      entry.entry_date.year,
      entry.entry_date.month,
      entry.entry_date.day,
      entry.created_at.hour,
      entry.created_at.min,
      entry.created_at.sec
    )
  end
end
