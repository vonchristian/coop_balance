module TimeDeposits 
  class BreakContractsController < ApplicationController 
    def new 
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @break_contract = TimeDeposits::BreakContractForm.new 
    end 
    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @break_contract = TimeDeposits::BreakContractForm.new(break_contract_params)
      if @break_contract.valid?
        @break_contract.save 
        redirect_to time_deposit_url(@time_deposit), alert: "Break contract saved successfully."
      else 
        render :new
      end 
    end 

    private
    def break_contract_params
      params.require(:time_deposits_break_contract_form).permit(:time_deposit_id, :recorder_id, :amount, :break_contract_amount, :reference_number, :date)
    end 
  end 
end 