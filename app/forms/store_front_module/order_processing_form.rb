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


    def create_reference_number(order)
      if order.cash? || order.check?
        OfficialReceipt.create_receipt(order)
      elsif order.credit?
        Invoices::SalesInvoice.create_invoice(order)
      end
    end
    def create_entry(order)
      cash_on_hand = order.employee.cash_on_hand_account
      accounts_receivable = CoopConfigurationsModule::StoreFrontConfig.default_accounts_receivable_account
      cost_of_goods_sold = CoopConfigurationsModule::StoreFrontConfig.default_cost_of_goods_sold_account
      sales = CoopConfigurationsModule::StoreFrontConfig.default_sales_account
      merchandise_inventory = CoopConfigurationsModule::StoreFrontConfig.default_merchandise_inventory_account
      if order.cash? || order.check?
        AccountingModule::Entry.create!( recorder_id: order.employee_id,
                                         commercial_document: order.customer,
                                         entry_date: order.date,
                                         description: "Payment for order",
                                         debit_amounts_attributes: [{ amount: order.total_cost,
                                                                      account: cash_on_hand,
                                                                      commercial_document: order},
                                                                    { amount: order.cost_of_goods_sold,
                                                                      account: cost_of_goods_sold,
                                                                      commercial_document: order } ],
                                          credit_amounts_attributes:[{amount: order.total_cost,
                                                                      account: sales,
                                                                      commercial_document: order},
                                                                     {amount: order.cost_of_goods_sold,
                                                                      account: merchandise_inventory,
                                                                      commercial_document: order}])
      elsif order.credit?
        AccountingModule::Entry.create!(
          commercial_document: order.customer,
          entry_date: order.date,
          description: "Credit purchase of #{order.customer_name}",
          debit_amounts_attributes:
          [{  amount: order.total_cost,
              account: accounts_receivable,
              commercial_document: order.customer},
          {   amount: order.cost_of_goods_sold,
              account: cost_of_goods_sold,
              commercial_document: order.customer}
          ],
          credit_amounts_attributes:
          [{  amount: order.total_cost,
              account: sales,
              commercial_document: order.customer },
          {   amount: order.cost_of_goods_sold,
              account: merchandise_inventory,
              commercial_document: order.customer}])
      end
    end

    def create_order
      order = StoreFrontModule::Order.create!(customer_id: customer_id,
                   date: date,
                   customer_type: customer_type,
                   pay_type: pay_type,
                   employee_id: employee_id,
                   cash_tendered: cash_tendered,
                   order_change: order_change,
                   total_cost: total_cost
                   )
      remove_cart_reference(order)
      create_reference_number(order)
      create_entry(order)

    end
    def create_entry(order)
      if order.cash? || order.check?
        create_cash_entry(order)
      elsif order.credit?
        create_credit_entry(order)
      end
    end
    def remove_cart_reference(order)
      StoreFrontModule::Cart.find_by(id: cart_id).line_items.each do |item|
        item.cart_id = nil
        order.line_items << item
      end
    end



  end
end
