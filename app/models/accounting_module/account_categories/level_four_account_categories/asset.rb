module AccountingModule
  module AccountCategories
    module LevelFourAccountCategories
      class Asset < LevelFourAccountCategory
        self.normal_credit_balance = false
        
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
