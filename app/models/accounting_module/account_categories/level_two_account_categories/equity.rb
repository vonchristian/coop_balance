module AccountingModule
  module AccountCategories
    module LevelTwoAccountCategories
      class Equity < LevelTwoAccountCategory
        self.normal_credit_balance = true

        def balance(options={})
          super(options)
        end
    
        def self.balance(options={})
          super(options)
        end
      end
    end
  end
end
