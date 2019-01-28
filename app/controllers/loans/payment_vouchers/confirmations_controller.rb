module Loans
  module PaymentVouchers
    class ConfirmationsController < ApplicationController
      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @voucher = current_cooperative.vouchers.find(params[:payment_voucher_id])
        @schedule = @loan.amortization_schedules.find(params[:schedule_id])
        ActiveRecord::Base.transaction do
          @entry_processing = Vouchers::EntryProcessing.new(
            voucher:    @voucher,
            employee:   current_user,
            updateable: @loan
          ).process!
          LoansModule::AmortizationPaymentUpdater.new(
            loan:     @loan, 
            schedule: @schedule, 
            voucher:  @voucher, 
            entry:    @voucher.entry
          ).update_status!
        end

        redirect_to loan_payments_url(@loan), notice: "Payment saved successfully."
      end
    end
  end
end