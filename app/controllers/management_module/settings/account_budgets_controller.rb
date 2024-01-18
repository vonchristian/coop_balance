module ManagementModule
  module Settings
    class AccountBudgetsController < ApplicationController
      def index
        @expenses = AccountingModule::Expense.all
        @revenues = AccountingModule::Revenue.all
      end
    end
  end
end