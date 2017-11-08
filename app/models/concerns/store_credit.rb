class StoreCredit
  def balance(customer)
    CoopConfigurationsModule::AccountReceivableStoreConfig.balance_for(customer) +
    customer.loans.disbursed.map{|a| a.store_payment_total }.sum
  end
end
