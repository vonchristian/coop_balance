module AccountingModule
  class NetSurplusComputation
    attr_reader :office, :date 

    def initialize(office:, date:)
      @office             = office 
      @date               = date 
      @net_income_config  = office.current_net_income_config
      @net_income_account = @net_income_config.net_income_account
      @from_date          = @net_income_config.beginning_date
      @to_date            = @net_income_config.ending_date

    end 

    def compute! 
      if net_income_account.entries.entered_on(from_date: from_date, to_date: to_date).present?
        net_surplus
      else 
        temp_net_net_surplus
      end 
    end 

    private 

    def temp_net_net_surplus 
      office.level_one_account_categories.revenues.balance(from_date: beginning_date_for(date), to_date: end_date_for(date)) - 
      office.level_one_account_categories.expenses.balance(from_date: beginning_date_for(date), to_date: end_date_for(date))
    end 

    def net_surplus 
      net_income_account.balance(from_date: beginning_date_for(date), to_date: end_date_for(date))
    end 
    

  end 
end 