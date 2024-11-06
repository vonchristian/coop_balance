module ManagementModule
  module Settings
    class AccountBudgetsController < ApplicationController
      def index
        @expenses = AccountingModule::Account.expense.all
        @revenues = AccountingModule::Account.revenue.all
      end
    end
  end
end
