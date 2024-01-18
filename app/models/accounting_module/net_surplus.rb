module AccountingModule
  class NetSurplus
    attr_reader :revenues, :expenses, :from_date, :to_date

    def initialize(args)
      @revenues  = args[:revenues]
      @expenses  = args[:expenses]
      @from_date = args[:from_date]
      @to_date   = args[:to_date]
    end

    def net_surplus(_args = {})
      revenues.balance(from_date: from_date, to_date: to_date) -
        expenses.balance(from_date: from_date, to_date: to_date)
    end
  end
end
