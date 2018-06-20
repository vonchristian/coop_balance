class AccountingModuleController < ApplicationController
  def index
    @revenues = AccountingModule::Revenue.active.all
    @expenses = AccountingModule::Expense.active.all
  end
end
