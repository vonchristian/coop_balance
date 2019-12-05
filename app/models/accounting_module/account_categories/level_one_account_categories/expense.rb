module AccountingModule
  module AccountCategories
    module LevelOneAccountCategories
      class Expense < LevelOneAccountCategory
        self.normal_credit_balance = false

      end
    end
  end
end
