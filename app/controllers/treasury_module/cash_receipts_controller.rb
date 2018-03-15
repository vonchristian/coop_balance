module TreasuryModule
  class CashReceiptsController < ApplicationController
    def index
      @cash_receipts = current_user.cash_on_hand_account.debit_entries.order(entry_date: :desc).
      paginate(page: params[:page], per_page: 25)
    end
  end
end