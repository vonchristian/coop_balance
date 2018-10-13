module TreasuryModule
  class VoucherProcessingsController < ApplicationController
    def create
      @cash_receipt = Vouchers::VoucherProcessing.new(cash_receipt_params)
      @cash_receipt.process!
      redirect_to voucher_url(@cash_receipt.find_voucher.id), notice: "Voucher created successfully."
    end
    private
    def cash_receipt_params
      params.require(:vouchers_voucher_processing).permit(:reference_number, :date, :description, :employee_id, :payee_id, :cooperative_service_id, :account_number)
    end
  end
end
