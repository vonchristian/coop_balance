module AccountingModule
  module Entries
    class CashDisbursementsController < ApplicationController
      def index
        @entries = current_cooperative.
        cash_accounts.
        credit_entries.
        order(entry_date: :desc).
        paginate(page: params[:page]).per_page(25)
      end
    end
  end
end
