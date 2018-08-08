module Members
  class MergingLineItemsController < ApplicationController
    def new
      @current_member = Member.find(params[:member_id])
      @merging_line_item = Members::MergingLineItem.new
      authorize []
      @merging = Members::Merging.new
      if params[:search].present?
        @members = Member.where.not(id: @current_member.id).text_search(params[:search]).paginate(page: params[:page], per_page: 20)
      else
        @members = Member.where.not(id: @current_member.id).text_search(@current_member.last_name).paginate(page: params[:page], per_page: 20)
      end
    end
    def create
      @current_member = Member.find(params[:member_id])
      @merging_line_item = Members::MergingLineItem.new(merging_line_item_params)
      @merging_line_item.save
      redirect_to new_member_merging_line_item_url(@current_member)
    end

    private
    def merging_line_item_params
      params.require(:members_merging_line_item).
      permit(:cart_id, :old_member_id)
    end
  end
end
