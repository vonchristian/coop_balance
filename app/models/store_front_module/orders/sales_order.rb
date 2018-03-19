module StoreFrontModule
  module Orders
    class SalesOrder < Order
      has_many :sales_line_items, class_name: "StoreFrontModule::LineItems::SalesLineItem",
                                 extend: StoreFrontModule::QuantityBalanceFinder, foreign_key: 'order_id'
      def self.total_income
        sum(&:income)
      end

      def self.cash_sales
        select{ |order| !order.credit_sales? }
      end

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
        total_cost - cost_of_goods_sold
      end

      def cost_of_goods_sold
        sales_order_line_items.cost_of_goods_sold
      end

      def credit_sales?
        CoopConfigurationsModule::StoreFrontConfig.default_accounts_receivable_account.debit_amounts.where(commercial_document: self).present?
      end
    end
  end
end
