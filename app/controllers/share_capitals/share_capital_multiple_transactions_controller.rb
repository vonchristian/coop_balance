module ShareCapitals
  class ShareCapitalMultipleTransactionsController < ApplicationController
    def new
      if params[:search].present?
        @pagy, @share_capitals = pagy(current_office.share_capitals.text_search(params[:search]))
      else
        @pagy, @share_capitals = pagy(current_office.share_capitals)
      end
      @share_capital_multiple_transaction = ShareCapitals::MultiplePaymentVoucherProcessing.new
    end
  end
end