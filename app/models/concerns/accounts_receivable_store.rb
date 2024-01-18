class AccountsReceivableStore
  def balance(customer)
    balance = []
    StoreFront.find_each do |store_front|
      balance << store_front.accounts_receivable_account.balance(commercial_document: customer)
    end
    balance.sum
  end
end
