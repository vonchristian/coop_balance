module AccountingModule
  module Accounts
    class ReportsController < ApplicationController
      def index
        @account = AccountingModule::Account.find(params[:account_id])
      end
    end
  end
end
