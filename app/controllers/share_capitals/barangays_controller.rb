module ShareCapitals
  class BarangaysController < ApplicationController
    respond_to :html, :json

    def edit
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      respond_modal_with @share_capital
    end

    def update
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @share_capital.update(share_capital_params)
      respond_modal_with @share_capital, 
        location: share_capital_url(@share_capital), 
        notice: "Barangay updated successfully."
    end

    private
    def share_capital_params
      params.require(:memberships_module_share_capital).
      permit(:barangay_id)
    end
  end
end
