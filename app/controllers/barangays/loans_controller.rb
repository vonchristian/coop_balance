module Barangays
  class LoansController < ApplicationController
    def index
      @barangay = Addresses::Barangay.find(params[:barangay_id])
      @loans = @barangay.loans.includes( :loan_product => [loans_receivable_current_account: :subsidiary_accounts] )
    end
  end
end
