class BarangaysController < ApplicationController
  def show
    @barangay = Addresses::Barangay.find(params[:id])
  end
end
