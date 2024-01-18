module ShareCapitals
  class MafBeneficiariesController < ApplicationController
    respond_to :html, :json

    def edit
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      respond_modal_with @share_capital
    end

    def update
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @share_capital.update(share_capital_params)
      respond_modal_with @share_capital,
                         location: share_capital_url(@share_capital)
    end

    private

    def share_capital_params
      params.require(:memberships_module_share_capital).permit(:maf_beneficiaries)
    end
  end
end