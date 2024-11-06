class AccountingModuleController < ApplicationController
  def index
    @revenues = current_cooperative.accounts.revenue.active
    @expenses = current_cooperative.accounts.expense.active.all
  end
end
