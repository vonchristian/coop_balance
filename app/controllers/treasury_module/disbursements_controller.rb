module TreasuryModule
  class DisbursementsController < ApplicationController
    def index
      @cash_disbursements = if params[:search].present?
                              current_cooperative.employee_cash_accounts.cash_accounts.credit_entries.text_search(params[:search]).order(entry_date: :desc).paginate(page: params[:page], per_page: 25)
      else
                              current_cooperative.employee_cash_accounts.cash_accounts.credit_entries.order(entry_date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
