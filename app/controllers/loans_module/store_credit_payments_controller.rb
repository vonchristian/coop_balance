module LoansModule
  class StoreCreditPaymentsController < ApplicationController
    def new
      @loan = LoansModule::Loan.find(params[:loan_id])
      @additional_charge = Charge.new
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @additional_charge = Charge.new(additional_charge_params)
      if @additional_charge.valid?
        @additional_charge.save
        @loan.loan_charges.create(chargeable: @additional_charge, commercial_document: @loan)
        redirect_to loans_module_loan_application_url(@loan), notice: "Store Payment created successfully"
      else
        render :new
      end
    end

    private
    def additional_charge_params
      params.require(:charge).permit(:name, :amount, :account_id)
    end
  end
end
