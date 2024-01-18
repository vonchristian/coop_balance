module ProgramSubscriptions
  class VoucherConfirmationsController < ApplicationController
    def create
      @program_subscription = current_cooperative.program_subscriptions.find(params[:program_subscription_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        redirect_to program_subscription_url(@program_subscription), notice: 'Program subscription payment saved successfully.'
      end
    end
  end
end
