module AccountingDepartment
  class Asset < Account

    def balance(options={})
      super(options)
    end

    def self.balance(options={})
      super(options)
    end
  end
end
