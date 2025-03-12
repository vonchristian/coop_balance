module StoreFrontModule
  module Suppliers
    class VoucherConfirmationsController < ApplicationController
      def create
        @voucher = current_cooperative.vouchers.find(params[:voucher_id])
        @supplier = current_cooperative.suppliers.find(params[:supplier_id])
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        redirect_to store_front_module_supplier_url(@supplier), notice: "Confirmed successfully."
      end
    end
  end
end
