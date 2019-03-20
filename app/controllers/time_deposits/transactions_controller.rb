module TimeDeposits
  class TransactionsController < ApplicationController
    
    def index
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @entries = @time_deposit.entries.sort_by(&:entry_date_and_created_at).reverse.paginate(:page => params[:page], :per_page => 20)
    end
  end
end