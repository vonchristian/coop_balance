class AccountsReceivableStore
  def balance(customer)
    CoopConfigurationsModule::StoreFrontConfig.default_accounts_receivable_account.balance(commercial_document_id: customer.id)
  end
end
