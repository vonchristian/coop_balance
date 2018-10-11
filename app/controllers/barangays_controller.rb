class BarangaysController < ApplicationController
  def index
    @barangays = current_cooperative.barangays.paginate(page: params[:page], per_page: 25)
  end
  def show
    @barangay = Addresses::Barangay.find(params[:id])
    @members = @barangay.members
  end
end
