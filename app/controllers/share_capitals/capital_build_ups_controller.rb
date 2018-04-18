module ShareCapitals
  class CapitalBuildUpsController < ApplicationController
    def new
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @capital_build_up = Memberships::ShareCapitals::CapitalBuildUpProcessing.new
      authorize [:share_capitals, :capital_build_up]
    end

    def create
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @capital_build_up = Memberships::ShareCapitals::CapitalBuildUpProcessing.new(share_capital_params)
      authorize [:share_capitals, :capital_build_up]
      if @capital_build_up.valid?
        @capital_build_up.save
        redirect_to share_capital_url(@share_capital), notice: "Capital build up saved successfully."
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:memberships_share_capitals_capital_build_up_processing).permit(:share_capital_id, :or_number, :date, :amount, :employee_id, :depositor_id)
    end
  end
end
