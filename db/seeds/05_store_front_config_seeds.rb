CoopConfigurationsModule::StoreFrontConfig.create(
  accounts_receivable_account: AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (General Merchandise)"),
  cost_of_goods_sold_account: AccountingModule::Account.find_by(name: "Cost of Goods Sold"),
  sales_account: AccountingModule::Account.find_by(name: "Sales"),
  merchandise_inventory_account: AccountingModule::Account.find_by(name: "Merchandise Inventory"))
