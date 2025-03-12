module Members
  class AccountMergingsController < ApplicationController
    def new
      @merging = AccountMerging.new
      @merger = current_cooperative.member_memberships.find(params[:member_id])
    end

    def create
      @merging = AccountMerging.new(account_merging_params)
      @merger = current_cooperative.member_memberships.find(params[:member_id])
      if @merging.valid?
        @merging.merge!
        redirect_to member_url(@merger), notice: "Account merged successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def account_merging_params
      params.require(:account_merging).permit(:mergee_id, :merger_id)
    end
  end
end
