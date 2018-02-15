# purchase order line item
# 40 pc
# 40 pc
# sales order line item
# 4 dozen = 48 dozen
module StoreFrontModule
  module LineItems
    class ReferencedPurchaseOrderLineItem < LineItem
      belongs_to :sales_order_line_item
      belongs_to :purchase_order_line_item
    end
  end
end
