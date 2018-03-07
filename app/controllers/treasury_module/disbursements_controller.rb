module TreasuryModule
  class DisbursementsController < ApplicationController
    def index
      if params[:search].present?
        @disbursements = AccountingModule::Entry.text_search(params[:search]).order(entry_date: :desc).paginate(page: params[:page], per_page: 25)
      else
        @disbursements = current_user.cash_on_hand_account.credit_entries.order(entry_date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
