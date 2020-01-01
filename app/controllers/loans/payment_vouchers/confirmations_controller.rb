module Loans
  module PaymentVouchers
    class ConfirmationsController < ApplicationController
      def create
        @loan     = current_cooperative.loans.find(params[:loan_id])
        @voucher  = Voucher.find(params[:payment_voucher_id])
        @schedule = LoansModule::AmortizationSchedule.find(params[:schedule_id]) if @loan.not_forwarded?
        Vouchers::EntryProcessing.new(
          voucher:    @voucher,
          employee:   current_user,
          updateable: @loan
        ).process!
        if @loan.not_forwarded?
          LoansModule::AmortizationPaymentUpdater.new(
            loan:     @loan,
            schedule: @schedule,
            voucher:  @voucher
          ).update_status!
        end
        LoansModule::Loans::PaidAtUpdater.new(loan: loan, date: @voucher.date).update_paid_at!

        redirect_to loan_payments_url(@loan), notice: "Payment saved successfully."
      end
    end
  end
end
