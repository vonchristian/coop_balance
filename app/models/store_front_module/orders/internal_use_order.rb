module StoreFrontModule
  module Orders
    class InternalUseOrder < Order
      has_many :internal_use_line_items, class_name: 'StoreFrontModule::LineItems::InternalUseLineItem', foreign_key: 'order_id'

      def employee
        commercial_document
      end
    end
  end
end
