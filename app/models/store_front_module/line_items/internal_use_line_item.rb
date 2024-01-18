module StoreFrontModule
  module LineItems
    class InternalUseLineItem < LineItem
      belongs_to :internal_use_order, class_name: 'StoreFrontModule::Orders::InternalUseOrder',
                                      foreign_key: 'order_id'
      belongs_to :purchase_line_item, class_name: 'StoreFrontModule::LineItems::PurchaseLineItem'
    end
  end
end
