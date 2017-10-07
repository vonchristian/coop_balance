module MembershipsModule 
  class SavingsAccountsController < ApplicationController
    def index 
      @member = Member.find(params[:member_id])
      @savings = @member.savings
    end 

    def new
      @member = Member.find(params[:member_id])
      @saving = SavingForm.new
    end

    def create
      @member = Member.find(params[:member_id])
      @saving = SavingForm.new(saving_params)
      if @saving.valid?
        @saving.save
        redirect_to management_module_member_url(@member), notice: "Success"
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:saving_form).permit(:account_number, :saving_product_id, :member_id, :or_number, :date, :amount)
    end
  end 
end