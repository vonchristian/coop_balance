module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class Asset < LevelTwoAccountCategory
        self.normal_credit_balance = false
      end
    end
  end
end
