module ShareCapitals
  class AccountClosingsController <ApplicationController
    def new
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @account_closing = ShareCapitals::AccountClosingForm.new
      authorize [:share_capitals, :account_closing]
    end
    def create
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @account_closing = ShareCapitals::AccountClosingForm.new(account_closing_params)
      authorize [:share_capitals, :account_closing]
      if @account_closing.valid?
        @account_closing.save
        redirect_to share_capital_url(@share_capital), alert: "ShareCapital Account closed successfully"
      else
        render :new
      end
    end

    private
    def account_closing_params
      params.require(:share_capitals_account_closing_form).permit(:amount, :reference_number, :date, :recorder_id, :share_capital_id, :closing_account_fee)
    end
  end
end
