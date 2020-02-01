module AccountingModule
  module AccountCategories
    module LevelFourAccountCategories
      class Asset < LevelFourAccountCategory
        self.normal_credit_balance = false
      end
    end
  end
end
