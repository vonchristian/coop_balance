module AccountingModule
  module AccountCategories
    module LevelOneAccountCategories
      class Asset < LevelOneAccountCategory
        self.normal_credit_balance = false
      end
    end
  end
end
