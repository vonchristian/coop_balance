class OfficesController < ApplicationController
  def index
    @offices = current_cooperative.offices.paginate(page: params[:page], per_page: 25)
  end

  def show
    @office = current_cooperative.offices.find(params[:id])
  end
end
