module AccountingModule
  module AccountCategories
    module LevelThreeAccountCategories
      class Expense < LevelThreeAccountCategory
        self.normal_credit_balance = false

      end
    end
  end
end
