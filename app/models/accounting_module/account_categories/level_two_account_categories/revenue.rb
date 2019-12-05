module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class Revenue < LevelTwoAccountCategory
        self.normal_credit_balance = true
      end
    end
  end
end
