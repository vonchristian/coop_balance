class BarangaysController < ApplicationController
  def index
   	if params[:search].present?
      @barangays = current_cooperative.barangays.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @barangays = current_cooperative.barangays.paginate(page: params[:page], per_page: 25)
    end
  end
  def show
    @barangay = current_cooperative.barangays.find(params[:barangay_id])
    @members = @barangay.members.paginate(page: params[:page], per_page: 25)
  end
end
