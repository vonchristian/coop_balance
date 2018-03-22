class AccountsReceivableStore
  def balance(customer)
    balance = []
    StoreFront.all.each do |store_front|
      balance << store_front.caccounts_receivable_account.balance(commercial_document: customer)
    end
    balance.sum
  end
end
