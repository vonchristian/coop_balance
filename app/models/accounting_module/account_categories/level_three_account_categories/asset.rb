module AccountingModule
  module AccountCategories
    module LevelThreeAccountCategories
      class Asset < LevelThreeAccountCategory
        self.normal_credit_balance = false
      end
    end
  end
end
