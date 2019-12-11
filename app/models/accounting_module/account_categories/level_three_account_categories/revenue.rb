module AccountingModule
  module AccountCategories
    module LevelThreeAccountCategories
      class Revenue < LevelThreeAccountCategory
        self.normal_credit_balance = true
      end
    end
  end
end
