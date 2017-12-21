class StoreCredit
  def balance(customer)
    if customer.loans.disbursed_loans.present?
      CoopConfigurationsModule::AccountReceivableStoreConfig.balance_for(customer) +
      customer.loans.disbursed_loans.map{|a| a.store_payment_total }.sum
    else
      CoopConfigurationsModule::AccountReceivableStoreConfig.balance_for(customer)
    end
  end
end
