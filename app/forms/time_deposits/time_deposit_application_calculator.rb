module TimeDeposits 
  class TimeDepositApplicationCalculator 
    include ActiveModel::Model 
    attr_accessor :amount 

    def calculate_amount 
      amount 
    end 
  end 
end 