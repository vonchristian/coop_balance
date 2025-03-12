module StoreFrontModule
  module Suppliers
    class VoucherAmountsController < ApplicationController
      def new
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @voucher = StoreFrontModule::Suppliers::VoucherProcessing.new
        @amount = StoreFrontModule::Suppliers::VoucherAmountProcessing.new
      end

      def create
        @supplier = Supplier.find(params[:supplier_id])
        @amount = StoreFrontModule::Suppliers::VoucherAmountProcessing.new(amount_params)
        if @amount.valid?
          @amount.process!
          redirect_to new_store_front_module_supplier_voucher_amount_url(@supplier), notice: "added successfully."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @supplier = Supplier.find(params[:supplier_id])
        @voucher_amount = Vouchers::VoucherAmount.find(params[:id])
        @voucher_amount.destroy
        redirect_to new_store_front_module_supplier_voucher_amount_url(@supplier), notice: "Removed successfully."
      end

      private

      def amount_params
        params.require(:store_front_module_suppliers_voucher_amount_processing).permit(:amount, :account_id, :amount_type, :supplier_id, :cooperative_id)
      end
    end
  end
end
