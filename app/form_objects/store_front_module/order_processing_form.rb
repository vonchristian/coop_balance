module StoreFrontModule
  class OrderProcessingForm
    include ActiveModel::Model
    include ActiveModel::Callbacks
    attr_accessor :customer_id,
                  :customer_type,
                  :date,
                  :pay_type,
                  :cash_tendered,
                  :order_change,
                  :total_cost,
                  :employee_id,
                  :cart_id,
                  :date
    validates :cart_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        create_order
      end
    end


    def add_line_items_from_cart(order)
      StoreModule::Cart.find_by(id: cart_id).line_items.each do |item|
        item.cart_id = nil
        order.line_items << item
      end
    end
    def create_entry(order)
      cash_on_hand = order.employee.cash_on_hand_account
      accounts_receivable = CoopConfigurationsModule::StoreFrontConfig.default_accounts_receivable_account
      cost_of_goods_sold = CoopConfigurationsModule::StoreFrontConfig.default_cost_of_goods_sold_account
      sales = CoopConfigurationsModule::StoreFrontConfig.default_sales_account
      merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
      if order.cash? || order.check?
        AccountingModule::Entry.create!( recorder_id: order.employee_id, commercial_document: order.customer, entry_date: order.date, description: "Payment for order",
          debit_amounts_attributes: [{amount: order.total_cost, account: cash_on_hand, commercial_document: order}, {amount: order.stock_cost, account: cost_of_goods_sold, commercial_document: order}],
          credit_amounts_attributes:[{amount: order.total_cost, account: sales, commercial_document: order}, {amount: order.stock_cost, account: merchandise_inventory, commercial_document: order}])
      elsif credit?
        AccountingModule::Entry.create!(commercial_document: order.customer, entry_date: order.date, description: "Credit order",
          debit_amounts_attributes: [{amount: order.total_cost, account: accounts_receivable, commercial_document: order}, {amount: order.stock_cost, account: cost_of_goods_sold, commercial_document: order}],
          credit_amounts_attributes:[{amount: order.total_cost, account: sales, commercial_document: order}, {amount: order.stock_cost, account: merchandise_inventory, commercial_document: order}])
      end
    end

    def create_order
      order = StoreModule::Order.create!(customer_id: customer_id,
                   date: date,
                   customer_type: customer_type,
                   pay_type: pay_type,
                   employee_id: employee_id,
                   cash_tendered: cash_tendered,
                   order_change: order_change,
                   total_cost: total_cost
                   )
      StoreModule::Cart.find_by(id: cart_id).line_items.each do |item|
        item.cart_id = nil
        order.line_items << item
      end
      StoreFrontModule::OrderProcessingForm.new.create_entry(order)
    end



  end
end
