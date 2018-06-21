module AccountingModule
  class Revenue < Account

    self.normal_credit_balance = true

    def balance(options={})
      super(options)
    end
    def self.balance(options={})
      super(options)
    end
  end
end
