module Barangays
  class SavingsController < ApplicationController
    def index
      @barangay = Addresses::Barangay.find(params[:barangay_id])
      @savings = @barangay.savings
    end
  end
end
