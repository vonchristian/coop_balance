module SavingsAccounts
  class AccountClosingsController <ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @account_closing = AccountClosingForm.new
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @account_closing = AccountClosingForm.new(account_closing_params)
      if @account_closing.valid?
        @account_closing.save
        redirect_to savings_account_url(@savings_account), alert: "Savings Account closed successfully"
      else
        render :new
      end
    end

    private
    def account_closing_params
      params.require(:account_closing_form).permit(:amount, :reference_number, :date, :recorder_id, :savings_account_id)
    end
  end
end
