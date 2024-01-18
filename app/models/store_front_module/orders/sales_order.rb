module StoreFrontModule
  module Orders
    class SalesOrder < Order
      has_many :sales_line_items, class_name: 'StoreFrontModule::LineItems::SalesLineItem'
      def self.total_income
        sum(&:income)
      end

      def self.cash_sales
        select { |order| !order.credit_sales? }
      end

      def self.credit_sales
        select(&:credit_sales?)
      end

      def customer_name
        commercial_document_name
      end

      def customer
        commercial_document
      end

      def income
        total_cost - cost_of_goods_sold
      end

      delegate :cost_of_goods_sold, to: :sales_line_items
    end
  end
end
