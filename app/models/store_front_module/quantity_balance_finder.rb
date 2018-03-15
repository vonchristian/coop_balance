module StoreFrontModule
  module QuantityBalanceFinder
    def balance(options={})
      if options[:from_date].present? && options[:to_date].present?
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        joins(:order).where('orders.date' => (date_range.start_date)..(date_range.end_date)).total
      elsif options[:product].present?
        joins(:product).where(product: options[:product]).total
      else
        joins(:order).total
      end
    end
  end
end
