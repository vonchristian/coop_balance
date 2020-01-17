module SavingsModule
  class InterestComputation 
    attr_reader :saving, :date, :applicable_rate

    def initialize(saving:, date:)
      @saving                         = saving 
      @date                           = date 
      @saving_product                 = @saving.saving_product
      @saving_product_interest_config = @saving_product.saving_product_interest_config
     
    end 

    def compute_interest!
      saving.averaged_balance * applicable_rate
    end 

    def applicable_rate
      @saving_product_interest_config.applicable_rate
    end 
  end 
end 