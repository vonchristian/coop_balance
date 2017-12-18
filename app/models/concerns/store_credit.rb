class StoreCredit
  def balance(customer)
    if customer.loans.disbursed.present?
      CoopConfigurationsModule::AccountReceivableStoreConfig.balance_for(customer) +
      customer.loans.disbursed.map{|a| a.store_payment_total }.sum
    else
      CoopConfigurationsModule::AccountReceivableStoreConfig.balance_for(customer)
    end
  end
end
