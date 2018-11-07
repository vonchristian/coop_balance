class AccountingModuleController < ApplicationController
  def index
    @revenues = current_cooperative.accounts.revenues.active
    @expenses = current_cooperative.accounts.expenses.active.all
  end
end
