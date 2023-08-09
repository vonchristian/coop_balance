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
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @barangay = current_cooperative.barangays.find(params[:id])
    end

    def update
      @barangay = current_cooperative.barangays.find(params[:id])
      if @barangay.update(barangay_params)
        redirect_to barangay_url(@barangay), notice: 'Barangay updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
    def barangay_params
      params.require(:addresses_barangay).permit(:avatar, :name, :municipality_id)
    end
  end
end
