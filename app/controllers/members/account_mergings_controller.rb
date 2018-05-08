module Members
  class AccountMergingsController < ApplicationController
    def new
      @merging = AccountMerging.new
      @merger = Member.find(params[:member_id])
    end
    def create
      @merging = AccountMerging.new(account_merging_params)
      @merger = Member.find(params[:member_id])
      if @merging.valid?
        @merging.merge!
        redirect_to member_url(@merger), notice: "Account merged successfully."
      else
        render :new
      end
    end

    private
    def account_merging_params
      params.require(:account_merging).permit(:mergee_id, :merger_id)
    end
  end
end
