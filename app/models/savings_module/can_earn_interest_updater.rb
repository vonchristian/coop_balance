module SavingsModule
  class CanEarnInterestUpdater 
    attr_reader :saving, :ending_date, :saving_product

    def initialize(saving:)
      @saving                         = saving 
      @saving_product                 = @saving.saving_product
      @saving_product_interest_config = @saving_product.saving_product_interest_config
     
    end 

    def update_can_earn_interest
      return false if !saving_product.can_earn_interest?

      if saving.averaged_balance >= minimum_balance 
        saving.update!(can_earn_interest: true)
      end 
    end 

    def minimum_balance
      @saving_product_interest_config.minimum_balance
    end 
  end 
end 