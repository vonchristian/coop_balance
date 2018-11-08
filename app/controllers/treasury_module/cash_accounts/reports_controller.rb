module TreasuryModule
  module CashAccounts
    class ReportsController < ApplicationController
      def index
        @cash_account = current_user.cash_accounts.find(params[:cash_account_id])
      end
    end
  end
end
