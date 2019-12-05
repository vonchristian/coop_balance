module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class Expense < LevelTwoAccountCategory
        self.normal_credit_balance = false

      end
    end
  end
end
