module Cooperatives
  class BarangaysController < ApplicationController
    def new
      @cooperative = current_cooperative
      @barangay = current_cooperative.barangays.build
    end
    def create
      @cooperative =current_cooperative
      @barangay = current_cooperative.barangays.create(barangay_params)
      if @barangay.valid?
        @barangay.save
        redirect_to barangay_url(@barangay), notice: "Barangay created successfully"
      else
        render :new
      end
    end

    private
    def barangay_params
      params.require(:addresses_barangay).permit(:avatar, :name, :municipality_id)
    end
  end
end
