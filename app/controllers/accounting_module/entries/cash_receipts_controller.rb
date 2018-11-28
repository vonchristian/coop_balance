module AccountingModule
  module Entries
    class CashReceiptsController < ApplicationController
      def index
        if params[:account_id].present?
          @entries = current_cooperative.cash_accounts.find(params[:account_id]).debit_entries.order(entry_date: :desc).paginate(page: params[:page]).per_page(25)
        else
          @entries = current_cooperative.cash_accounts.debit_entries.order(entry_date: :desc).paginate(page: params[:page]).per_page(25)
        end
      end
    end
  end
end
