class AccountsReceivableStore
  def total_payments(borrower)
    # borrower.entries.map{|a| a.credit_amounts.distinct.where(account: CoopConfigurationsModule::AccountReceivableStoreConfig.account_to_debit).sum(&:amount) }.sum

    CoopConfigurationsModule::AccountReceivableStoreConfig.account_to_debit.credit_entries.where(commercial_document: borrower).map{|a| a.credit_amounts.distinct.sum(&:amount) }.sum
  end
end
