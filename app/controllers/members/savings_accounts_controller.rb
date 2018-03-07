module Members
  class SavingsAccountsController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
      @savings = @member.savings
    end

    def new
      @member = Member.find(params[:member_id])
      @saving = Memberships::SavingsAccountSubscription.new
      @cooperative = current_user.cooperative
      authorize [:members, :savings_account]
    end

    def create
      @member = Member.find(params[:member_id])
      @saving = Memberships::SavingsAccountSubscription.new(saving_params)
      if @saving.valid?
        @saving.save
        redirect_to savings_account_url(@saving.find_savings_account), notice: "Savings Account opened successfully."
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:memberships_savings_account_subscription).permit(:employee_id, :account_number, :saving_product_id, :depositor_id, :or_number, :date, :amount)
    end
  end
end
