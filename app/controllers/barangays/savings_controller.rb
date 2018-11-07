module Barangays
  class SavingsController < ApplicationController
    def index
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @savings = @barangay.savings
    end
  end
end
