module AccountingModule
  module IocDistributions
    class ShareCapitalProcessingsController < ApplicationController
      def new
        @share_capital = current_office.share_capitals.find(params[:share_capital_id])
        @ioc_payment   = AccountingModule::IocDistributions::IocToShareCapital.new
      end

      def create
        @share_capital = current_office.share_capitals.find(params[:accounting_module_ioc_distributions_ioc_to_share_capital][:share_capital_id])
        @ioc_payment = AccountingModule::IocDistributions::IocToShareCapital.new(ioc_to_share_capital_params)
        if @ioc_payment.valid?
          @ioc_payment.process!
          redirect_to new_accounting_module_ioc_distributions_share_capital_url, notice: "added successfully."
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def ioc_to_share_capital_params
        params.require(:accounting_module_ioc_distributions_ioc_to_share_capital)
              .permit(:cart_id, :employee_id, :amount, :share_capital_id)
      end
    end
  end
end
