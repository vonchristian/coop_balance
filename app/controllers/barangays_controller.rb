class BarangaysController < ApplicationController
  def index
    @barangays = Addresses::Barangay.all
  end
  def show
    @barangay = Addresses::Barangay.find(params[:id])
    @members = @barangay.members
  end
end
