module AccountingModule
  module AccountCategories
    module LevelFourAccountCategories
      class Revenue < LevelFourAccountCategory
        self.normal_credit_balance = true

      end
    end
  end
end
