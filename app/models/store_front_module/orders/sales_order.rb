module StoreFrontModule
  module Orders
    class SalesOrder < Order
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem",
                                 extend: StoreFrontModule::QuantityBalanceFinder, foreign_key: 'order_id'
      has_many :products, through: :sales_order_line_items, class_name: "StoreFrontModule::Product"
      def self.credit_sales
        select{ |order| order.credit_sales? }
      end

      def customer_name
        commercial_document_name
      end
      def customer
        commercial_document
      end
      def income
        sales_order_line_items.map{|a| a.cost_of_goods_sold }.compact.sum
      end

      def line_items_quantity(product)
        sales_order_line_items.where(product: product).sum(&:quantity)
      end

      def line_items_total_cost(product)
        sales_order_line_items.where(product: product).sum(&:total_cost)
      end
      def credit_sales?
        CoopConfigurationsModule::StoreFrontConfig.default_accounts_receivable_account.debit_amounts.where(commercial_document: self).present?
      end
    end
  end
end
