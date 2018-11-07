module Members
  class MergingLineItemsController < ApplicationController
    def new
      @current_member = current_cooperative.member_memberships.find(params[:member_id])
      @merging_line_item = Members::AccountMerging.new
      authorize @merging_line_item
      @merging = Members::Merging.new
      if params[:search].present?
        @members = current_cooperative.member_memberships.where.not(id: @current_member.id).text_search(params[:search]).paginate(page: params[:page], per_page: 20)
      else
        @members = current_cooperative.member_memberships.where.not(id: @current_member.id).text_search(@current_member.last_name).paginate(page: params[:page], per_page: 20)
      end
    end
    def create
      @current_member = current_cooperative.member_memberships.find(params[:member_id])
      @merging_line_item = Members::AccountMerging.new(merging_line_item_params)
      @merging_line_item.save
      redirect_to new_member_merging_line_item_url(@current_member)
    end

    private
    def merging_line_item_params
      params.require(:members_account_merging).
      permit(:cart_id, :old_member_id)
    end
  end
end
