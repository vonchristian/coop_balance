module StoreFrontModule
  module Orders
    class SpoilageOrderProcessing
      include ActiveModel::Model
      attr_accessor :description, :employee_id, :cart_id, :date

      validates :employee_id, :title, :content, :date, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_spoilage_order
        end
      end

      private

      def create_spoilage_order
        spoilage_order = StoreFrontModule::Orders::SpoilageOrder.create!(
          date: date,
          commercial_document: find_employee,
          employee: find_employee
        )
        find_cart.spoilage_line_items.each do |spoilage_line_item|
          spoilage_line_item.cart_id = nil
          spoilage_order.spoilage_line_items << spoilage_line_item
        end
        create_entry(spoilage_order)
      end

      def find_cart
        Cart.find_by(id: cart_id)
      end

      def find_employee
        User.find_by(id: employee_id)
      end

      def create_entry(spoilage_order)
        store_front = find_employee.store_front
        spoilage_account = store_front.spoilage_account
        merchandise_inventory = store_front.merchandise_inventory_account
        find_employee.entries.create!(
          origin: find_employee.store_front,
          commercial_document: spoilage_order,
          entry_date: date,
          description: description,
          debit_amounts_attributes: [ amount: spoilage_order.total_cost,
                                     account: spoilage_account,
                                     commercial_document: spoilage_order ],
          credit_amounts_attributes: [ account: merchandise_inventory,
                                      amount: spoilage_order.total_cost,
                                      commercial_document: spoilage_order ]
        )
      end
    end
  end
end
