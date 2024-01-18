module VarianceMonitoring
  def variance(args = {})
    (accounts.balance(to_date: args[:to_date]) - accounts.balance(to_date: args[:to_date].last_month.end_of_month))
  end
end
