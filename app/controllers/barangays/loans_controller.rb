module Barangays
  class LoansController < ApplicationController
    def index
      @barangay = Addresses::Barangay.find(params[:barangay_id])
      @loans = @barangay.loans
    end
  end
end
