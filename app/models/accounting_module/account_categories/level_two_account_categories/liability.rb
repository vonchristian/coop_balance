module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class Liability < LevelTwoAccountCategory
        self.normal_credit_balance = true

      end
    end
  end
end
