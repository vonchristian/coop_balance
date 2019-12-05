module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class Equity < LevelTwoAccountCategory
        self.normal_credit_balance = true
      end
    end
  end
end
