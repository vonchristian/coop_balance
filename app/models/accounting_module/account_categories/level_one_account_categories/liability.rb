module AccountingModule
  module AccountCategories
    module LevelOneAccountCategories
      class Liability < LevelOneAccountCategory
        self.normal_credit_balance = true

      end
    end
  end
end
