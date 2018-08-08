module ShareCapitals
  class BarangaysController < ApplicationController
    def edit
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
    end
    def update
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @share_capital.update(share_capital_params)
      if @share_capital.valid?
        @share_capital.save
        redirect_to share_capital_url(@share_capital), notice: "Barangay updated successfully."
      else
        render :edit
      end
    end

    private
    def share_capital_params
      params.require(:memberships_module_share_capital).
      permit(:barangay_id)
    end
  end
end
