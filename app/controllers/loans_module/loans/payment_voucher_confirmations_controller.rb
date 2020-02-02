module LoansModule
  module Loans
    class PaymentVoucherConfirmationsController < ApplicationController
      def create
        @loan    = current_office.loans.find(params[:loan_id])
        @voucher = current_office.vouchers.find(params[:voucher_id])
        ApplicationRecord.transaction do
          create_entry 
          update_paid_at
        end
        redirect_to loan_payments_url(@loan), notice: 'Transaction confirmed successfully.'
      end

      private 

      def create_entry
        Vouchers::EntryProcessing.new(updateable: @loan, voucher: @voucher, employee: current_user).process!
      end 

      def update_paid_at
        LoansModule::Loans::PaidAtUpdater.new(loan: @loan, date: @voucher.date).update_paid_at!
      end 
    end
  end
end
