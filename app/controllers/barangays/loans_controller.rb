module Barangays
  class LoansController < ApplicationController
    def index
      @barangay = Addresses::Barangay.find(params[:barangay_id])
      @loans = @barangay.loans.disbursed.not_archived.distinct.includes( :loan_product => [:loans_receivable_current_account] )
    end
  end
end
