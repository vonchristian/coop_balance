AccountingModule::Asset.create(code: 11100, name: "Cash and Cash Equivalents")
AccountingModule::Asset.create(code: 11110, name: "Cash on Hand")
AccountingModule::Asset.create(code: 111101, name: "Cash on Hand (Treasury)")
AccountingModule::Asset.create(code: 111102, name: "Cash on Hand (Teller)")
AccountingModule::Asset.create(code: 111103, name: "Cash on Hand (Vault)")
AccountingModule::Asset.create(code: 11120, name: "Checks and Other Cash Items (COCI)")
AccountingModule::Asset.create(code: 11130, name: "Cash in Bank")
AccountingModule::Asset.create(code: 11140, name: "Cash in Cooperative Federation")
AccountingModule::Asset.create(code: 11150, name: "Petty Cash Fund")
AccountingModule::Asset.create(code: 11160, name: "Revolving Fund")
AccountingModule::Asset.create(code: 11170, name: "Change Fund")
AccountingModule::Asset.create(code: 11200, name: "Investment at Fair Value through Profit or Loss")
AccountingModule::Asset.create(code: 11300, name: "Held-to-Maturity (HTM) Financial Assets")
AccountingModule::Asset.create(code: 11310, name: "Unamortized Discount/Premium - HTM")
AccountingModule::Asset.create(code: 11400, name: "Available-for-Sale (AFS) Financial Assets")
AccountingModule::Asset.create(code: 11410, name: "Accumulated Gains/Losses - AFS")
AccountingModule::Asset.create(code: 11420, name: "Allowance for Probable Losses - AFS FA")
AccountingModule::Asset.create(code: 11500, name: "Unquoted Debt Securities Classified As Loans")
AccountingModule::Asset.create(code: 11600, name: "Investment in Non-Marketable Equity (INMES)")
AccountingModule::Asset.create(code: 11610, name: "Allowance for Probable Losses -  INMES")
AccountingModule::Asset.create(code: 11700, name: "Loans and Receivables")
AccountingModule::Asset.create(code: 11711, name: "Loans Receivable - Current")
AccountingModule::Asset.create(code: 117111, name: "Loans Receivable - Current (Regular Loan)")
AccountingModule::Asset.create(code: 117112, name: "Loans Receivable - Current (Salary Loan)")
AccountingModule::Asset.create(code: 117113, name: "Loans Receivable - Current (Emergency Loan)")
AccountingModule::Asset.create(code: 117113, name: "Loans Receivable - Current (OFW Loan)")



AccountingModule::Asset.create(code: 11712, name: "Loans Receivable - Past Due")
AccountingModule::Asset.create(code: 11713, name: "Loans Receivable - Restructured")
AccountingModule::Asset.create(code: 11714, name: "Loans Receivable - Loans in Litigation")
AccountingModule::Asset.create(code: 11715, contra: true, name: "Unearned Interests and Discounts")
AccountingModule::Asset.create(code: 11715, contra: true, name: "Unearned Interests and Discounts")

AccountingModule::Asset.create(code: 11716, name: "Allowance for Probable Losses on Loans")
AccountingModule::Asset.create(code: 11721, name: "Accounts Receivables Trade - Current")
AccountingModule::Asset.create(code: 117212, name: "Accounts Receivables Trade - Current (General Merchandise)", main_account_id: AccountingModule::Asset.find_by(code: 11721, name: "Accounts Receivables Trade - Current").id )
AccountingModule::Asset.create(code: 117211, name: "Accounts Receivables - Loan Penalties")

AccountingModule::Asset.create(code: 11722, name: "Accounts Receivables Trade - Past Due")
AccountingModule::Asset.create(code: 11723, name: "Accounts Receivables Trade - Restructured")
AccountingModule::Asset.create(code: 11724, name: "Accounts Receivables Trade - in Litigation")
AccountingModule::Asset.create(code: 11725, name: "Allowance for Probable Losses on Accounts Receivable Trade")
AccountingModule::Asset.create(code: 11726, name: "Interests on Credit Receivables")
AccountingModule::Asset.create(code: 11730, name: "Installment Receivables - Current")
AccountingModule::Asset.create(code: 11731, name: "Installment Receivables - Past Due")
AccountingModule::Asset.create(code: 11733, name: "Installment Receivables - Restructured")
AccountingModule::Asset.create(code: 11734, name: "Installment Receivables - in Litigation")
AccountingModule::Asset.create(code: 11735, name: "Allowance for Probable Losses on Installment Receivables")
AccountingModule::Asset.create(code: 11736, contra: true, name: "Unrealized Gross Margin")
AccountingModule::Asset.create(code: 11740,  name: "Sales Contract Receivable")
AccountingModule::Asset.create(code: 11741,  name: "Allowance for Probable Losses - Sales Contract Receivable")
AccountingModule::Asset.create(code: 11750,  name: "Advances to Officers, Employees and Members")
AccountingModule::Asset.create(code: 11760,  name: "Due from Accountable Officers and Employees")
AccountingModule::Asset.create(code: 11770,  name: "Finance Lease Receivable")
AccountingModule::Asset.create(code: 11780,  name: "Other Current Receivables")
AccountingModule::Asset.create(code: 11800,  name: "Inventories")
AccountingModule::Asset.create(code: 11810,  name: "Merchandise Inventory")
AccountingModule::Asset.create(code: 11820,  name: "Reposessed Inventories")
AccountingModule::Asset.create(code: 11830,  name: "Spare Parts/Materials and Other Goods Inventory")
AccountingModule::Asset.create(code: 11840,  name: "Raw Materials Inventory")
AccountingModule::Asset.create(code: 11850,  name: "Work in Process Inventory")
AccountingModule::Asset.create(code: 11860,  name: "Finished Goods Inventory")
AccountingModule::Asset.create(code: 11870,  name: "Agricultural Produce")
AccountingModule::Asset.create(code: 11880,  name: "Equipment for Lease Inventory")
AccountingModule::Asset.create(code: 11890,  name: "Allowance for Decline in Value of Inventory", contra: true)
AccountingModule::Asset.create(code: 11900,  name: "Biological Assets")
AccountingModule::Asset.create(code: 12000,  name: "Other Current Assets")
AccountingModule::Asset.create(code: 12100,  name: "Input Tax")
AccountingModule::Asset.create(code: 12200,  name: "Deposit to Suppliers")
AccountingModule::Asset.create(code: 12300,  name: "Unused Supplies")
AccountingModule::Asset.create(code: 12400,  name: "Prepaid Expenses")
AccountingModule::Asset.create(code: 13100,  name: "Held-to-Maturity(HTM) Financial Assets")
AccountingModule::Asset.create(code: 13110,  name: "Unamortized Discount/Premium - HTM")
AccountingModule::Asset.create(code: 13120,  name: "Allowance for Probable Losses-HTM-LTFA")
AccountingModule::Asset.create(code: 13200,  name: "Available-for-Sale (AFS) Financial Assets")
AccountingModule::Asset.create(code: 13210,  name: "Accumulated Gains/Losses - AFS")
AccountingModule::Asset.create(code: 13220,  name: "Allowance for Probable Losses - AFS FA")
AccountingModule::Asset.create(code: 13300,  name: "Unquoted Debt Securities Classified As Loans")
AccountingModule::Asset.create(code: 13400,  name: "Investment in Non-Marketable Equity Securities (INMES)")
AccountingModule::Asset.create(code: 13410,  name: "Allowance for Probable Losses - INMES")
AccountingModule::Asset.create(code: 13500,  name: "Investment in Subsidiaries/Associates and Joint Ventures")
AccountingModule::Asset.create(code: 13600,  name: "Investment Property")
AccountingModule::Asset.create(code: 13610,  name: "Investment Property-Land")
AccountingModule::Asset.create(code: 13620,  name: "Investment Property-Building")
AccountingModule::Asset.create(code: 13630,  name: "Accumulated Depreciation and Impairment - Investment Property-Bldg.")
AccountingModule::Asset.create(code: 13700,  name: "Real and Other Properties (ROPA)")
AccountingModule::Asset.create(code: 13710,  name: "Allowance for Probable Losses - ROPA")
AccountingModule::Asset.create(code: 14000,  name: "Property, Plant and Equipment")
AccountingModule::Asset.create(code: 14110,  name: "Land")
AccountingModule::Asset.create(code: 14111,  name: "Accumulated Impairment Losses")
AccountingModule::Asset.create(code: 14120,  name: "Land Improvements")
AccountingModule::Asset.create(code: 14121,  name: "Accumulated Depreciation - Land Improvements")
AccountingModule::Asset.create(code: 14130,  name: "Building and Improvements")
AccountingModule::Asset.create(code: 14131,  name: "Accumulated Depreciation - Land Improvements")
AccountingModule::Asset.create(code: 14140,  name: "Building on Leased/Usufruct Land")
AccountingModule::Asset.create(code: 14141,  name: "Accumulated
 Depreciation - Building on Leased/Usufruct Land", contra: true )
 AccountingModule::Asset.create(code: 14150,  name: "Utility Plant")
 AccountingModule::Asset.create(code: 14151,  name: "Accumulated Depreciation - Utility Plant", contra: true)
 AccountingModule::Asset.create(code: 14160,  name: "Property, Plant and Equipment - Under Finance Lease")
 AccountingModule::Asset.create(code: 14161,  name: "Accumulated Depreciation - Property, Plant and Equipment - Under Finance Lease", contra: true)
 AccountingModule::Asset.create(code: 14170,  name: "Construction in Progress")
 AccountingModule::Asset.create(code: 14180,  name: "Furniture, Fixtures and Equipment (FFE)")
 AccountingModule::Asset.create(code: 14181,  name: "Accumulated Depreciation - FFE", contra: true)
 AccountingModule::Asset.create(code: 14190,  name: "Machineries, Tools and Equipment")
 AccountingModule::Asset.create(code: 14191,  name: "Accumulated Depreciation - Machineries, Tools and Equipment", contra: true)
 AccountingModule::Asset.create(code: 14200,  name: "Kitchen, Canteen and Catering Equipment/Utensils")
 AccountingModule::Asset.create(code: 14201,  name: "Accumulated Depreciation - Kitchen, Canteen and Catering Equipment/Utensils", contra: true)
 AccountingModule::Asset.create(code: 14210,  name: "Transportation Equipment")
 AccountingModule::Asset.create(code: 14211,  name: "Accumulated Depreciation - Transportation Equipment", contra: true)
 AccountingModule::Asset.create(code: 14220,  name: "Lines and Uniforms")
 AccountingModule::Asset.create(code: 14221,  name: "Accumulated Depreciation - Lines and Uniforms", contra: true)
 AccountingModule::Asset.create(code: 14230,  name: "Nursery/Greenhouses")
 AccountingModule::Asset.create(code: 14231,  name: "Accumulated Depreciation - Nursery/Greenhouses", contra: true)
 AccountingModule::Asset.create(code: 14240,  name: "Leasehold Rights and Improvements")
 AccountingModule::Asset.create(code: 15100,  name: "Biological Assets - Animals")
 AccountingModule::Asset.create(code: 15101,  name: "Accumulated Depreciation - Biological Assets - Animals", contra: true)
 AccountingModule::Asset.create(code: 15200,  name: "Biological Assets - Plants")
 AccountingModule::Asset.create(code: 15201,  name: "Accumulated Depreciation - Biological Assets - Plants", contra: true)
 AccountingModule::Asset.create(code: 16000,  name: "Intangible Assets")
 AccountingModule::Asset.create(code: 16100,  name: "Franchise")
 AccountingModule::Asset.create(code: 16200,  name: "Franchise Cost")
 AccountingModule::Asset.create(code: 16300,  name: "Copyright")
 AccountingModule::Asset.create(code: 16400,  name: "Patent")
 AccountingModule::Asset.create(code: 17000,  name: "Other Non-Current Assets")
 AccountingModule::Asset.create(code: 17100,  name: "Cooperative Development Cost")
 AccountingModule::Asset.create(code: 17200,  name: "Product/Business Development Cost")
 AccountingModule::Asset.create(code: 17300,  name: "Computerization Cost")
 AccountingModule::Asset.create(code: 17400,  name: "Other Funds and Deposits")
 AccountingModule::Asset.create(code: 17500,  name: "Finance Lease Receivable")
 AccountingModule::Asset.create(code: 17600,  name: "Due from Head Office/Branch/Subsidiary")
 AccountingModule::Asset.create(code: 17700,  name: "Assets Held for Sale")
 AccountingModule::Asset.create(code: 17800,  name: "Deposits on Returnable Containers")
 AccountingModule::Asset.create(code: 17900,  name: "Miscellaneous Assets")



#Liability
AccountingModule::Liability.create(code: 21000, name: 'Current Liabilities')
AccountingModule::Liability.create(code: 21100, name: 'Savings Deposits')
AccountingModule::Liability.create(code: 21200, name: 'Time Deposits')
AccountingModule::Liability.create(code: 21300, name: 'Accounts Payable-Trade')
AccountingModule::Liability.create(code: 21400, name: 'Accounts Payable-Non Trade')
AccountingModule::Liability.create(code: 21500, name: 'Loans Payable - Current')
AccountingModule::Liability.create(code: 21600, name: 'Finance Lease Payable - Current')
AccountingModule::Liability.create(code: 21700, name: 'Due to Regulatory Agencies')
AccountingModule::Liability.create(code: 217001, name: 'Loan Protection Fund Payable')

AccountingModule::Liability.create(code: 21800, name: 'Cash Bond Payable')
AccountingModule::Liability.create(code: 21900, name: 'SSS/ECC/Philhealth/Pag-ibig Premium Contributions Payable')
AccountingModule::Liability.create(code: 22000, name: 'SSS/Pag-ibig Loans Payable')
AccountingModule::Liability.create(code: 22100, name: 'Withholding Tax Payable')
AccountingModule::Liability.create(code: 221001, name: 'Documentary Stamp Taxes')
AccountingModule::Liability.create(code: 22200, name: 'Output Tax')
AccountingModule::Liability.create(code: 22300, name: 'VAT Payable')
AccountingModule::Liability.create(code: 22400, name: 'Accrued Expenses')
AccountingModule::Liability.create(code: 22500, name: 'Interest on Share Capital Payable')
AccountingModule::Liability.create(code: 22600, name: 'Patronage Refund Payable')
AccountingModule::Liability.create(code: 22700, name: 'Due to Union/Federation(CETF)')
AccountingModule::Liability.create(code: 22800, name: 'Deposits from Customers')
AccountingModule::Liability.create(code: 22900, name: 'Advances from Customers')
AccountingModule::Liability.create(code: 23000, name: 'School Program Support Fund Payable')
AccountingModule::Liability.create(code: 23100, name: 'Other Current Liabilities')
AccountingModule::Liability.create(code: 24000, name: 'Non-Current Liabilities')
AccountingModule::Liability.create(code: 24100, name: 'Loans Payable')
AccountingModule::Liability.create(code: 24200, name: 'Discounts on Loans Payable', contra: true)
AccountingModule::Liability.create(code: 24300, name: 'Bonds Payable')
AccountingModule::Liability.create(code: 24300, name: 'Bonds Payable')
AccountingModule::Liability.create(code: 24500, name: 'Revolving Capital Payable')
AccountingModule::Liability.create(code: 24600, name: 'Retirement Fund Payable')
AccountingModule::Liability.create(code: 24700, name: 'Finance Lease Payable - Long Term')
AccountingModule::Liability.create(code: 24800, name: 'Other Non-Current Liabilities')
AccountingModule::Liability.create(code: 24810, name: 'Project Subsidy Fund')
AccountingModule::Liability.create(code: 24820, name: "Members' Benefit and Other Funds Payable")
AccountingModule::Liability.create(code: 24830, name: 'Due to Head Office/Branch/Subsidiary')
AccountingModule::Liability.create(code: 24840, name: 'Other Non Current Liabilities')

#Equity
AccountingModule::Equity.create(code: 30000, name: 'Equity')
AccountingModule::Equity.create(code: 30100, name: "Members' Equity")
AccountingModule::Equity.create(code: 30110, name: 'Authorized Share Capital - Common')
AccountingModule::Equity.create(code: 30120, name: 'Unissued Share Capital - Common')
AccountingModule::Equity.create(code: 30130, name: 'Subscribed Share Capital - Common')
AccountingModule::Equity.create(code: 30140, name: 'Subscription Receivable - Common')
AccountingModule::Equity.create(code: 30150, name: 'Paid-up Share Capital - Common')
AccountingModule::Equity.create(code: 30160, name: 'Treasury Share Capital - Common')
AccountingModule::Equity.create(code: 30170, name: 'Authorized Share Capital - Preferred')
AccountingModule::Equity.create(code: 30180, name: 'Unissued Share Capital - Preferred')
AccountingModule::Equity.create(code: 30190, name: 'Subscribed Share Capital - Preferred')
AccountingModule::Equity.create(code: 30200, name: 'Subscription Receivable - Preferred')
AccountingModule::Equity.create(code: 30210, name: 'Paid-up Share Capital - Preferred')
AccountingModule::Equity.create(code: 30220, name: 'Treasury Shares Capital - Preferred')
AccountingModule::Equity.create(code: 30230, name: 'Deposit for Share Capital Subscription')
AccountingModule::Equity.create(code: 30300, name: 'Undivided Net Surplus')
AccountingModule::Equity.create(code: 30400, name: 'Net Loss')
AccountingModule::Equity.create(code: 30500, name: 'Donations/Grants')
AccountingModule::Equity.create(code: 30600, name: 'Statutory Funds')
AccountingModule::Equity.create(code: 30610, name: 'Reserve Fund')
AccountingModule::Equity.create(code: 30620, name: 'Coop. Education and Training Fund')
AccountingModule::Equity.create(code: 30630, name: 'Community Development Fund')
AccountingModule::Equity.create(code: 30640, name: 'Optional Fund')
AccountingModule::Equity.create(code: 30700, name: 'Unrealized Gains/Losses')

#Revenue

AccountingModule::Revenue.create(code: 40000, name: 'Revenue Items')
AccountingModule::Revenue.create(code: 40100, name: 'Income from Operations')
AccountingModule::Revenue.create(code: 40110, name: 'Interest Income from Loans')
AccountingModule::Revenue.create(code: 401101, name: 'Interest Income from Loans - Salary Loan')
AccountingModule::Revenue.create(code: 401102, name: 'Interest Income from Loans - Regular Loan')
AccountingModule::Revenue.create(code: 40120, name: 'Service Fees')

AccountingModule::Revenue.create(code: 401201, name: 'Service Fees - Inspection Fees')
AccountingModule::Revenue.create(code: 401202, name: 'Service Fees - Check Fees')
AccountingModule::Revenue.create(code: 401203, name: 'Closing Account Fees')
AccountingModule::Revenue.create(code: 4012031, name: 'Time Deposit Break Contract Fees')
AccountingModule::Revenue.create(code: 4012032, name: 'Savings Account Closing Fees')
AccountingModule::Revenue.create(code: 4012033, name: 'Share Capital Closing Fees')

AccountingModule::Revenue.create(code: 40130, name: 'Filing Fees')
AccountingModule::Revenue.create(code: 40140, name: 'Fines, Penalties, Surcharges')
AccountingModule::Revenue.create(code: 401401, name: 'Loan Penalties')

AccountingModule::Revenue.create(code: 40200, name: 'Income from Service Operations')
AccountingModule::Revenue.create(code: 40200, name: 'Service Income')

AccountingModule::Revenue.create(code: 40201, name: 'Interest Income from Credit Sales')
AccountingModule::Revenue.create(code: 40220, name: 'Interest Income from Lease Agreement')
AccountingModule::Revenue.create(code: 40300, name: 'Income from Marketing/Consumers/Production Operations Net Sales')
AccountingModule::Revenue.create(code: 40310, name: 'Sales')
AccountingModule::Revenue.create(code: 40320, name: 'Installment Sales')
AccountingModule::Revenue.create(code: 40330, name: 'Sales Returns and Allowances', contra: true)
AccountingModule::Revenue.create(code: 40340, name: 'Sales Discounts', contra: true)
AccountingModule::Revenue.create(code: 40400, name: 'Other Income')
AccountingModule::Revenue.create(code: 40410, name: 'Income/Interest from Investment/Deposits')
AccountingModule::Revenue.create(code: 40420, name: 'Membership Fee')
AccountingModule::Revenue.create(code: 40430, name: 'Commission Income')
AccountingModule::Revenue.create(code: 40440, name: 'Realized Gross Margin')
AccountingModule::Revenue.create(code: 40450, name: 'Miscellaneous Income')

#Expense Accounts
AccountingModule::Expense.create(code: 50000, name: 'Cost of Goods Sold')
AccountingModule::Expense.create(code: 51110, name: 'Purchases')
AccountingModule::Expense.create(code: 51120, name: 'Raw Material Purchases')
AccountingModule::Expense.create(code: 51130, name: 'Purchase Returns and Allowances', contra: true)
AccountingModule::Expense.create(code: 51140, name: 'Purchase Discounts', contra: true)
AccountingModule::Expense.create(code: 51160, name: 'Freight In')
AccountingModule::Expense.create(code: 51170, name: 'Direct Labor')
AccountingModule::Expense.create(code: 51180, name: 'Factory/Processing Overhead')
AccountingModule::Expense.create(code: 51200, name: 'Inventory Loss')
AccountingModule::Expense.create(code: 60000, name: 'Cost of Services')
AccountingModule::Expense.create(code: 60100, name: 'Project Management Cost (Cost of Services)')
AccountingModule::Expense.create(code: 61110, name: 'Labor and Technical Supervision (Cost of Services)')
AccountingModule::Expense.create(code: 61210, name: 'Salaries and Wages (Cost of Services)')
AccountingModule::Expense.create(code: 61230, name: "Employees' Benefits (Cost of Services)")
AccountingModule::Expense.create(code: 61240, name: "SSS, Philhealth, Pag-Ibig Contribution (Cost of Services)")
AccountingModule::Expense.create(code: 61250, name: "SSS, Philhealth, Pag-Ibig Contribution (Cost of Services)")
AccountingModule::Expense.create(code: 61260, name: "Retirement Benefit Expenses (Cost of Services)")
AccountingModule::Expense.create(code: 61280, name: "Professional and Consultancy Fees (Cost of Services)")
AccountingModule::Expense.create(code: 61370, name: "Supplies (Cost of Services)")
AccountingModule::Expense.create(code: 61410, name: "Power Light and Water (Cost of Services)")
AccountingModule::Expense.create(code: 61430, name: "Insurance (Cost of Services)")
AccountingModule::Expense.create(code: 62280, name: "Professional and Consultancy Fees (Cost of Services)")
AccountingModule::Expense.create(code: 62370, name: "Supplies (Cost of Services)")
AccountingModule::Expense.create(code: 62410, name: "Power, Light and Water (Cost of Se)")
AccountingModule::Expense.create(code: 62430, name: "Insurance (Marketing Dept.)")
AccountingModule::Expense.create(code: 62440, name: "Repairs and Maintenance (Marketing Dept.)")
AccountingModule::Expense.create(code: 62450, name: "Rentals (Marketing Dept.)")
AccountingModule::Expense.create(code: 62490, name: "Gas, Oil, and Lubricants (Marketing Dept.)")
AccountingModule::Expense.create(code: 62530, name: "Depreciation (Marketing Dept.)")
AccountingModule::Expense.create(code: 62540, name: "Amortization (Marketing Dept.)")
AccountingModule::Expense.create(code: 62590, name: "Impairment Loss (Marketing Dept.)")








AccountingModule::Expense.create(code: 70000, name: "Financing Cost")
AccountingModule::Expense.create(code: 71100, name: "Interest Expense on Borrowings", main_account_id: AccountingModule::Expense.find_by_name('Financing Cost') )
AccountingModule::Expense.create(code: 71200, name: "Interest Expense on Savings Deposits", main_account_id: AccountingModule::Expense.find_by_name('Financing Cost'))

AccountingModule::Expense.create(code: 71201, name: "Interest Expense on Time Deposits", main_account_id: AccountingModule::Expense.find_by_name('Financing Cost'))

AccountingModule::Expense.create(code: 71300, name: "Other Financing Charges", main_account_id: AccountingModule::Expense.find_by_name('Financing Cost'))

# #Selling/Marketing Cost Costs
AccountingModule::Expense.create(code: 72000, name: "Selling/Marketing Cost Cost")

AccountingModule::Expense.create(code: 72180, name: "Product/Service Marketing and Promotional Expenses", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72180, name: "Product/Service Marketing and Promotional Expenses", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72190, name: "Product/Service Development", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72200, name: "Product Research", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72210, name: "Salaries and Wages (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72220, name: "Incentives and Allowances (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72230, name: "Employee Benefits (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72240, name: "SSS, Philhealth, ECC, Pag-ibig Premium Contribution (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72250, name: "Retirement Benefit Expenses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72260, name: "Commission Expenses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72270, name: "Advertising and Promotion (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72280, name: "Professional Fees (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72290, name: "Royalties (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72310, name: "Store/Canteen/Kitchen and Catering Supplies Expenses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72320, name: "Breakage and Losses on Kitchen Utensils (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72330, name: "Freight Out/ Delivery Expenses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72340, name: "Spoilage, Breakage and Losses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72350, name: "Storage/Warehousing Expenses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72410, name: "Power, Light and Water (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72420, name: "Travel and Transportation (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72430, name: "Insurance (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72440, name: "Repairs and Maintenance (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72450, name: "Rentals (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72460, name: "Taxes, Fees and Charges (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72470, name: "Communication (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72480, name: "Representation (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72490, name: "Gas, Oil and Lubricants (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72520, name: "Miscellaneous Expenses (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72530, name: "Depereciation (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72540, name: "Amortization (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72550, name: "Amortization of Leasehold Rights and Improvement (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)
AccountingModule::Expense.create(code: 72560, name: "Periodicals, Magazines and Subscription (Selling/Marketing Cost)", main_account_id: AccountingModule::Account.find_by_name('Selling/Marketing Cost Cost').id)

AccountingModule::Expense.create(code: 73000, name: "Administrative Cost")
AccountingModule::Expense.create(code: 73210, name: "Salaries and Wages", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73230, name: "Employees Benefits",  main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73240, name: "SSS, Philhealth, ECC, Pag-ibig Premium Contributions", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73250, name: "Retirement Benefits", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73270, name: "Officers' Honorarium and Allowances", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73300, name: "Litigation Expenses", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73360, name: "School Program Support", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73370, name: "Office Supplies", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73380, name: "Meetings and Conferences", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73390, name: "Trainings/Seminars", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73410, name: "Power, Light and Water", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73420, name: "Travel and Transportation", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73430, name: "Insurance", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73440, name: "Repairs and Maintenance", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73450, name: "Rentals", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73460, name: "Taxes, Fees and Charges", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73470, name: "Communication", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73480, name: "Representation", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73490, name: "Gas, Oil and Lubricants", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73500, name: "Collection Expense", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73510, name: "General Support Services", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73520, name: "Miscellaneous Expense", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73530, name: "Depreciation", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73540, name: "Amortization", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73550, name: "Amortization of Leasehold Rights and Improvement", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73560, name: "Provision for Probable Losses on Accounts/Installment Receivables", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73570, name: "Provision for Losses - Others",  main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73590, name: "Impairment Losses", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73600, name: "Bank Charges", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73610, name: "General Assembly Expenses", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73620, name: "Members Benefit Expenses", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73630, name: "Affiliation Fee", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73640, name: "Social and Community Service Expense",  main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 73650, name: "Provisions for CGF(KBGF)", main_account_id: AccountingModule::Account.find_by_name('Administrative Cost').id)
AccountingModule::Expense.create(code: 80000, name: 'Other Items - Subsidy/Gain (Losses)')
AccountingModule::Expense.create(code: 81000, name: 'Project Subsidy', contra: true)
AccountingModule::Expense.create(code: 82000, name: 'Donation and Grant Subsidy')
AccountingModule::Expense.create(code: 83000, name: 'Optional Fund Subsidy')
AccountingModule::Expense.create(code: 84000, name: 'Subsidized Project Expenses')
AccountingModule::Expense.create(code: 85000, name: 'Gains or Losses on Sale of Property and and Equipment')
AccountingModule::Expense.create(code: 86000, name: 'Gains or Losses from Investment')
AccountingModule::Expense.create(code: 87000, name: 'Gains or Losses on Sale of Reposessed Item')
AccountingModule::Expense.create(code: 88000, name: 'Gains or Losses from Foreign Exchange Valuation')
AccountingModule::Expense.create(code: 89000, name: "Prior Years' Adjustment")
