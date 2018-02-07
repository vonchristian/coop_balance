module CoopConfigurationsModule
  class StoreFrontConfig < ApplicationRecord
    belongs_to :cost_of_goods_sold_account, class_name: "AccountingModule::Account"
    belongs_to :accounts_receivable_account,  class_name: "AccountingModule::Account"
    belongs_to :merchandise_inventory_account, class_name: "AccountingModule::Account"
    belongs_to :sales_account, class_name: "AccountingModule::Account"

    validates :cost_of_goods_sold_account_id,
              :accounts_receivable_account_id,
              :merchandise_inventory_account_id,
              :sales_account_id,
              presence: true
    def self.default_accounts_receivable_account
      return self.order(created_at: :asc).last.accounts_receivable_account if self.any?
      AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (General Merchandise)")
    end
    def self.default_cost_of_goods_sold_account
      return self.order(created_at: :asc).last.cost_of_goods_sold_account if self.any?
      AccountingModule::Account.find_by(name: "Cost of Goods Sold")
    end
    def self.default_sales_account
      return self.order(created_at: :asc).last.sales_account if self.any?
      AccountingModule::Account.find_by(name: "Sales")
    end

    def self.default_sales_return_account
      return self.order(created_at: :asc).last.sales_return_account if self.any?
      AccountingModule::Account.find_by(name: "Sales Returns and Allowances")
    end

    def self.default_merchandise_inventory_account
      return self.order(created_at: :asc).last.merchandise_inventory_account if self.any?
      AccountingModule::Account.find_by(name: "Merchandise Inventory")
    end
  end
end
