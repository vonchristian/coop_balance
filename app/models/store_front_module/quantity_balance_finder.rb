module StoreFrontModule
  module QuantityBalanceFinder
    def balance(_args = {})
      includes(:product, :order).processed.total_converted_quantity
    end
  end
end
