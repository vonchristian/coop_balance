module ShareCapitals
  class BalanceTransfersController < ApplicationController

    def new
      @origin_share_capital      = current_office.share_capitals.find(params[:share_capital_id])
      @subscriber                = @origin_share_capital.subscriber
      @subscriber_share_capitals = @subscriber.share_capitals
      @balance_transfer          = ShareCapitals::BalanceTransferProcessing.new
      @balance_transfer_voucher  = ShareCapitals::BalanceTransferVoucher.new

      if params[:search].present?
        @pagy, @share_capitals = pagy(current_office.share_capitals.text_search(params[:search]))
      else
        @pagy, @share_capitals = pagy(current_office.share_capitals.where.not(id: @subscriber_share_capitals.ids))
      end
    end
  end
end
