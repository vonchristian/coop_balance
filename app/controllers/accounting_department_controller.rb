class AccountingDepartmentController < ApplicationController
  def index
    @cash_on_hand = AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
end
