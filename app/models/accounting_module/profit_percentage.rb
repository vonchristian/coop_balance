module AccountingModule
  module ProfitPercentage
    def profit_percent(args = {})
      100 - ((expenses.balance(args) / revenues.balance(args)) * 100)
    end
  end
end
