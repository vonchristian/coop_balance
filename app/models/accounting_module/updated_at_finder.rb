module AccountingModule
  module UpdatedAtFinder
    def updated_at(args = {})
      from_date  = args.fetch(:from_date)
      to_date    = args.fetch(:to_date)
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      includes(:entries).where('entries.entry_date' => date_range.start_date..date_range.end_date)
    end
  end
end
