class MembersController < ApplicationController
  def index
    if params[:search].present?
      @members = Member.text_search(params[:search]).order(:last_name)
    else 
      @members = Member.all.order(:last_name)
    end
  end
  def show
    @member = Member.find(params[:id])
  end
end 