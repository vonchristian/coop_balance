class AccountingModuleController < ApplicationController
  def index
    @cash_on_hand = AccountingModule::Account.find_by(name: "Cash on Hand")
    @cash_in_bank = AccountingModule::Account.find_by(name: "Cash in Bank")
    @petty_cash = AccountingModule::Account.find_by(name: "Petty Cash Fund")


  end
end
