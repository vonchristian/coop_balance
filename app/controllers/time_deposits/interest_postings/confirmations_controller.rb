module TimeDeposits
  module InterestPostings
    class ConfirmationsController < ApplicationController
      def create
        @voucher      = current_office.vouchers.find(params[:voucher_id])
        @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
        ActiveRecord::Base.transaction do
          Vouchers::EntryProcessing.new(updateable: @time_deposit, voucher: @voucher, employee: current_user).process!
        end
        redirect_to time_deposit_url(@time_deposit), notice: "Interest posting transaction saved successfully."
      end
    end
  end
end
