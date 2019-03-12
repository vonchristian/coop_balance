module ProgramSubscriptions
  class VouchersController < ApplicationController
    def show
      @program_subscription = MembershipsModule::ProgramSubscription.find(params[:program_subscription_id])
      @voucher = Voucher.find(params[:id])
    end
  end
end
