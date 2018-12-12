class BarangaysController < ApplicationController
  def index
   	if params[:search].present?
      @barangays = current_cooperative.barangays.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @barangays = current_cooperative.barangays.paginate(page: params[:page], per_page: 25)
    end
  end
  def show
    @barangay = current_cooperative.barangays.find(params[:id])
    if params[:search].present?
      @members = @barangay.member_memberships.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @members = @barangay.member_memberships
      @paginated = @members.uniq.paginate(page: params[:page], per_page: 25)
    end
  end
end
