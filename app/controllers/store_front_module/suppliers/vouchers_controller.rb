module StoreFrontModule
  module Suppliers
    class VouchersController < ApplicationController
      def index
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @vouchers = @supplier.vouchers.order(date: :desc).paginate(page: params[:page], per_page: 35)
      end
      def new
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @voucher = StoreFrontModule::Suppliers::VoucherProcessing.new
        @amount = StoreFrontModule::Suppliers::VoucherAmountProcessing.new
      end
      def create
        @supplier = Supplier.find(params[:supplier_id])
        @amount = StoreFrontModule::Suppliers::VoucherAmountProcessing.new
        @voucher = StoreFrontModule::Suppliers::VoucherProcessing.new(voucher_params)
        if @voucher.valid?
          @voucher.process!
          redirect_to store_front_module_supplier_voucher_url(supplier_id: @supplier.id, id: @voucher.find_voucher.id), notice: "Voucher created successfully."

        else
          redirect_to new_store_front_module_supplier_voucher_amount_url(@supplier)
        end
      end

      def show
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @voucher = current_cooperative.vouchers.find(params[:id])
      end

      def destroy
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        @voucher = current_cooperative.vouchers.find(params[:id])
        @voucher.destroy
        redirect_to store_front_module_supplier_url(@supplier), notice: "Voucher destroyed successfully."
      end

      private
      def voucher_params
        params.require(:store_front_module_suppliers_voucher_processing).permit(:date, :supplier_id, :account_number, :description, :reference_number, :preparer_id)
      end
    end
  end
end
