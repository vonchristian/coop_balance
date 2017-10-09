class ShareCapitalsController < ApplicationController
  def index
    if params[:search].present?
      @share_capitals = MembershipsModule::ShareCapital.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
    else
      @share_capitals = MembershipsModule::ShareCapital.all.paginate(page: params[:page], per_page: 30)
    end
  end
  def show 
    @share_capital = MembershipsModule::ShareCapital.find(params[:id])
  end
end
