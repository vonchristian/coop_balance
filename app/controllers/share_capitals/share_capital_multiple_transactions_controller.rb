module ShareCapitals
  class ShareCapitalMultipleTransactionsController < ApplicationController
    def new 
      @pagy, @share_capitals              = pagy(current_office.share_capitals)
      @share_capital_multiple_transaction = ShareCapitals::MultiplePaymentVoucherProcessing.new 
    end 
  end 
end 