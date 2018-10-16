module SavingsAccounts
  class AccountClosingsController <ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @account_closing = SavingsAccounts::Closing.new
      authorize [:savings_accounts, :account_closing]
    end

    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @account_closing = SavingsAccounts::Closing.new(account_closing_params)
      authorize [:savings_accounts, :account_closing]

      if @account_closing.valid?
        @account_closing.process!
        redirect_to savings_account_voucher_url(savings_account_id: @savings_account.id, id: @account_closing.find_voucher.id), notice: "Account closing voucher created successfully."
      else
        render :new
      end
    end

    private
    def account_closing_params
      params.require(:savings_accounts_closing).permit(:amount, :reference_number, :date, :recorder_id, :savings_account_id, :closing_account_fee, :cash_account_id, :account_number)
    end
  end
end
