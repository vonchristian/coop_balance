module AccountingModule
  module Accounts
    class SettingsController < ApplicationController
      def index
        @account = current_office.accounts.find(params[:account_id])
      end
    end
  end
end
