module Members
  class SavingsAccountsController < ApplicationController
    def index
      @member = Member.friendly.find(params[:member_id])
      @savings = @member.savings
    end

    def new
      @member = Member.friendly.find(params[:member_id])
      @saving = SavingForm.new
      @cooperative = current_user.cooperative
      authorize [:members, :savings_account]
    end

    def create
      @member = Member.friendly.find(params[:member_id])
      @saving = SavingForm.new(saving_params)
      if @saving.valid?
        @saving.save
        redirect_to member_savings_accounts_url(@member), notice: "Savings Account opened successfully."
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:saving_form).permit(:recorder_id, :account_number, :saving_product_id, :depositor_id, :depositor_type, :or_number, :date, :amount)
    end
  end
end
