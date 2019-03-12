class BarangaysController < ApplicationController
  def index
   	if params[:search].present?
      @barangays = current_cooperative.barangays.search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @barangays = current_cooperative.barangays.paginate(page: params[:page], per_page: 25)
    end
    @barangays_import = Barangays::ImportsProcessing.new
  end
  
  def show
    @barangay = current_cooperative.barangays.find(params[:id])
    @members = @barangay.members.paginate(page: params[:page], per_page: 25)
  end
end
