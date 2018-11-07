module Barangays
  class LoansController < ApplicationController
    def index
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @loans = @barangay.loans.disbursed.not_archived.includes( :loan_product => [:loans_receivable_current_account] )
    end
  end
end
