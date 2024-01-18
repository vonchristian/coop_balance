class MembershipsController < ApplicationController
  def index
    @memberships = if params[:search].present?
                     current_cooperative.memberships.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
                   else
                     current_cooperative.memberships.all.paginate(page: params[:page], per_page: 25)
                   end
  end

  def show
    @membership = current_cooperative.memberships.find(params[:id])
  end

  def edit
    @membership = current_cooperative.memberships.find(params[:id])
  end
end
