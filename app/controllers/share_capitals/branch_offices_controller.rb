module ShareCapitals
  class BranchOfficesController < ApplicationController
    def edit
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
    end
    def update
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @share_capital.update(share_capital_params)
      if @share_capital.save
        redirect_to share_capital_url(@share_capital), notice: "Branch Office updated successfully"
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:memberships_module_share_capital).permit(:branch_office_id)
    end
  end
end
