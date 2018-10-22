module Members
  class TinsController < ApplicationController
    respond_to :html, :json

    def new
      @member = Member.find(params[:member_id])
      @tin = @member.tins.build
      respond_modal_with @tin
    end

    def create
      @member = Member.find(params[:member_id])
      @tin = @member.tins.create(tin_params)
      respond_modal_with @tin, location: member_info_index_url(@member), notice: "TIN Number updated successfully"
    end

    private
    def tin_params
      params.require(:tin).permit(:number)
    end
  end
end
