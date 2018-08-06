class MembershipsController < ApplicationController
  def index
    if params[:search].present?
      @memberships = Membership.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @memberships = Membership.all.paginate(page: params[:page], per_page: 25)
    end
  end
  def show
    @membership = Membership.find(params[:id])
  end
  def edit
    @membership = Membership.find(params[:id])
  end
end
