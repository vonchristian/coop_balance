module Barangays
  class LoansController < ApplicationController
    def index
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @loans = @barangay.loans.disbursed.not_archived.includes(loan_product: [:current_account])
    end
  end
end
