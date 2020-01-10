module SavingsAccounts 
  class SavingsAccountMultipleTransactionsController < ApplicationController
    def new 
      if params[:search].present?
        @pagy, @savings_accounts = pagy(current_office.savings.text_search(params[:search]))
      else 
        @pagy, @savings_accounts = pagy(current_office.savings)
      end 
      @savings_account_multiple_transaction = SavingsAccounts::MultiplePaymentVoucherProcessing.new 
    end 
  end 
end 