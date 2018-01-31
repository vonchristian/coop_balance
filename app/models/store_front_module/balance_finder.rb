module StoreFrontModule
  module BalanceFinder
    def balance(options={})
      if options[:from_date].present? && options[:to_date].present?
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      joins(:entry, :account).where('entries.entry_date' => (date_range.start_date)..(date_range.end_date)).total
    end
  end
end
