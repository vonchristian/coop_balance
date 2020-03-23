module AccountingModule
  module IocDistributions
    class SavingProcessingsController < ApplicationController
      def new 
        @saving      = current_office.savings.find(params[:saving_id])
        @ioc_payment = AccountingModule::IocDistributions::IocToSaving.new 
      end 

      def create
        @saving      = current_office.savings.find(params[:accounting_module_ioc_distributions_ioc_to_saving][:saving_id])
        @ioc_payment = AccountingModule::IocDistributions::IocToSaving.new (ioc_to_saving_params)
        if @ioc_payment.valid?
          @ioc_payment.process! 
          redirect_to new_accounting_module_ioc_distributions_saving_url, notice: "added successfully."
        else 
          render :new 
        end 
      end 

      private 
      def ioc_to_saving_params
        params.require(:accounting_module_ioc_distributions_ioc_to_saving).
        permit(:cart_id, :employee_id, :amount, :saving_id)
      end 
    end 
  end 
end 