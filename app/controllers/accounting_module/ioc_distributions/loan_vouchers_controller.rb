module AccountingModule
  module IocDistributions
    class LoanVouchersController < ApplicationController
      def create
        @voucher = AccountingModule::IocDistributions::IocVoucher.new(voucher_params)
        if @voucher.valid?
          @voucher.process!
          @find_voucher = current_office.vouchers.find_by(account_number: params[:accounting_module_ioc_distributions_ioc_voucher][:account_number])
          redirect_to accounting_module_ioc_distributions_loan_voucher_url(@find_voucher), notice: "Voucher created successfully."
        else
          redirect_to new_accounting_module_ioc_distributions_loan_url, alert: "Error"
        end
      end

      def show
        @voucher = current_office.vouchers.find(params[:id])
        @pagy, @voucher_amounts = pagy(@voucher.voucher_amounts)
      end

      def destroy
        @voucher = current_office.vouchers.find(params[:id])
        return if @voucher.disbursed?

        @voucher.destroy
        redirect_to new_accounting_module_ioc_distributions_loan_url, notice: "Transaction cancelled successfully."
      end

      private

      def voucher_params
        params.require(:accounting_module_ioc_distributions_ioc_voucher)
              .permit(:date, :reference_number, :description, :cart_id, :employee_id, :account_number)
      end
    end
  end
end
