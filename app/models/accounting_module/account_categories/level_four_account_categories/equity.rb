module AccountingModule
  module AccountCategories
    module LevelFourAccountCategories
      class Equity < LevelFourAccountCategory
        self.normal_credit_balance = true

        def self.balance(options={})
          super(options)
        end
        
        def balance(options={})
          super(options)
        end
      end
    end
  end
end
