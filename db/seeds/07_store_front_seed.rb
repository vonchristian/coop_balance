poblacion = StoreFront.build(name: "KCCMC Poblacion Storefront", address: "Poblacion, Tinoc, Ifugao", contact_number: "")
tukucan = StoreFront.build(name: "KCCMC Tukucan Storefront", address: "Tukucan, Tinoc, Ifugao", contact_number: "")
mansoyosoy = StoreFront.build(name: "KCCMC Mansoyosoy Storefront", address: "Mansoyosoy, Tinoc, Ifugao", contact_number: "")

poblacion.merchandise_inventory_account = AccountingModule::Asset.create(code: 118101,  name: "Merchandise Inventory (Poblacion Storefront)")
tukucan.merchandise_inventory_account = AccountingModule::Asset.create(code: 118102,  name: "Merchandise Inventory (Tukucan Storefront)")
mansoyosoy.merchandise_inventory_account = AccountingModule::Asset.create(code: 118103,  name: "Merchandise Inventory (Mansoyosoy Storefront)")

poblacion.cost_of_goods_sold_account = AccountingModule::Expense.create(code: 500001, name: 'Cost of Goods Sold (Poblacion Storefront)')
tukucan.cost_of_goods_sold_account = AccountingModule::Expense.create(code: 500002, name: 'Cost of Goods Sold (Tukucan Storefront)')
mansoyosoy.cost_of_goods_sold_account = AccountingModule::Expense.create(code: 500003, name: 'Cost of Goods Sold (Mansoyosoy Storefront)')

poblacion.sales_account = AccountingModule::Revenue.create(code: 403101, name: 'Sales (Poblacion Storefront)')
tukucan.sales_account = AccountingModule::Revenue.create(code: 403102, name: 'Sales (Tukucan Storefront)')
mansoyosoy.sales_account = AccountingModule::Revenue.create(code: 403103, name: 'Sales (Mansoyosoy Storefront)')

poblacion.accounts_payable_account = AccountingModule::Liability.create(code: 213001, name: 'Accounts Payable-Trade (Poblacion Storefront)')
tukucan.accounts_payable_account = AccountingModule::Liability.create(code: 213002, name: 'Accounts Payable-Trade (Tukucan Storefront)')
mansoyosoy.accounts_payable_account = AccountingModule::Liability.create(code: 213003, name: 'Accounts Payable-Trade (Mansoyosoy Storefront)')

poblacion.sales_return_account = AccountingModule::Revenue.create(code: 403301, name: 'Sales Returns and Allowances (Poblacion Storefront)', contra: true)
tukucan.sales_return_account = AccountingModule::Revenue.create(code: 403302, name: 'Sales Returns and Allowances (Tukucan Storefront)', contra: true)
mansoyosoy.sales_return_account = AccountingModule::Revenue.create(code: 403303, name: 'Sales Returns and Allowances (Mansoyosoy Storefront)', contra: true)

poblacion.accounts_receivable_account = AccountingModule::Asset.create(code: 117212, name: "Accounts Receivables Trade - Current (Poblacion Storefront)", main_account_id: AccountingModule::Asset.find_by(code: 11721, name: "Accounts Receivables Trade - Current").id )
tukucan.accounts_receivable_account = AccountingModule::Asset.create(code: 117213, name: "Accounts Receivables Trade - Current (Tukucan Storefront)", main_account_id: AccountingModule::Asset.find_by(code: 11721, name: "Accounts Receivables Trade - Current").id )
mansoyosoy.accounts_receivable_account = AccountingModule::Asset.create(code: 117214, name: "Accounts Receivables Trade - Current (Mansoyosoy Storefront)", main_account_id: AccountingModule::Asset.find_by(code: 11721, name: "Accounts Receivables Trade - Current").id )


poblacion.spoilage_account = AccountingModule::Expense.create(code: 723401, name: "Spoilage, Breakage and Losses (Poblacion Storefront)")
tukucan.spoilage_account = AccountingModule::Expense.create(code: 723402, name: "Spoilage, Breakage and Losses (Tukucan Storefront)")
mansoyosoy.spoilage_account = AccountingModule::Expense.create(code: 723403, name: "Spoilage, Breakage and Losses (Mansoyosoy Storefront)")

poblacion.sales_discount_account = AccountingModule::Revenue.create(code: 403401, name: 'Sales Discounts (Poblacion Storefront)', contra: true)
tukucan.sales_discount_account = AccountingModule::Revenue.create(code: 403402, name: 'Sales Discounts (Tukucan Storefront)', contra: true)
mansoyosoy.sales_discount_account = AccountingModule::Revenue.create(code: 403403, name: 'Sales Discounts (Mansoyosoy Storefront)', contra: true)

poblacion.save!
tukucan.save!
mansoyosoy.save!

