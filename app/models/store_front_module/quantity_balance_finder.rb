module StoreFrontModule
  module QuantityBalanceFinder
    def balance(options={})
      if options[:from_date].present? && options[:to_date].present?
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        joins(:order).processed.where('orders.date' => (date_range.start_date)..(date_range.end_date)).total_converted_quantity
      elsif options[:product].present?
        joins(:product, :order).processed.where(product: options[:product]).total_converted_quantity
      elsif options[:purchase_line_item].present?
        where(purchase_line_item: options[:purchase_line_item]).processed.total_converted_quantity
      else
        joins(:order).processed.total_converted_quantity
      end
    end
  end
end
