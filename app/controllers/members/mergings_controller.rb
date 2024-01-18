module Members
  class MergingsController < ApplicationController
    def create
      @current_member = current_cooperative.member_memberships.find(params[:member_id])
      @merging = Members::Merging.new(merging_params)
      @merging.merge!
      redirect_to member_url(@current_member), notice: 'Member accounts merged successfully.'
    end

    private

    def merging_params
      params.require(:members_merging)
            .permit(:cart_id, :current_member_id)
    end
  end
end
