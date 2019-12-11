module AccountingModule
  module AccountCategories
    module LevelThreeAccountCategories
      class Equity < LevelThreeAccountCategory
        self.normal_credit_balance = true
      end
    end
  end
end
