module StoreFrontModule
  module Orders
    class SpoilageOrderProcessing
      include ActiveModel::Model
      attr_accessor  :title, :content, :employee_id, :cart_id, :date

      validates :employee_id, :title, :content, :date, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_spoilage_order
        end
      end

      private
      def create_spoilage_order
        spoilage_order = StoreFrontModule::Orders::SpoilageOrder.create!(date: date, employee: find_employee)
        spoilage_order.create_note!(title: title, content: content)
        find_cart.spoilage_order_line_items.each do |spoilage_order_line_item|
          spoilage_order_line_item.cart_id = nil
          spoilage_order.spoilage_order_line_items << spoilage_order_line_item
        end
        create_entry(spoilage_order)
      end

      def find_cart
        Cart.find_by_id(cart_id)
      end

      def find_employee
        User.find_by_id(employee_id)
      end

      def create_entry(spoilage_order)
        spoilage_account = AccountingModule::Account.find_by(name: "Spoilage, Breakage and Losses (Selling/Marketing Cost)")
        merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
        find_employee.entries.create!(
          commercial_document: spoilage_order,
          entry_date: spoilage_order.date,
          description: "Spoilage of merchandise inventories",
          debit_amounts_attributes: [amount: spoilage_order.total_cost,
                                    account: spoilage_account,
                                    commercial_document: spoilage_order ],
          credit_amounts_attributes:[account: merchandise_inventory,
                                     amount: spoilage_order.total_cost,
                                     commercial_document: spoilage_order])
      end
    end
  end
end
