class AccountingDepartmentController < ApplicationController
  def index
    @cash_on_hand = AccountingDepartment::Account.find_by(name: "Cash on Hand")
    @cash_in_bank = AccountingDepartment::Account.find_by(name: "Cash in Bank")
    @petty_cash = AccountingDepartment::Account.find_by(name: "Petty Cash Fund")


  end
end
