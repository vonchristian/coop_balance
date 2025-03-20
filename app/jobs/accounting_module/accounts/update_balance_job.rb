# frozen_string_literal: true

class AccountingModule::Accounts::UpdateBalanceJob < ApplicationJob
  queue_as :default

  def perform(id)
    account = AccountingModule::Account.find(id)
    account.touch
  end
end
