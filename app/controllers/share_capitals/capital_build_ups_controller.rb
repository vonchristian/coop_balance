module ShareCapitals
  class CapitalBuildUpsController < ApplicationController
    def new
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @capital_build_up = CapitalBuildUpForm.new
      authorize [:share_capitals, :capital_build_up]
    end

    def create
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @capital_build_up = CapitalBuildUpForm.new(share_capital_params)
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
      params.require(:capital_build_up_form).permit(:share_capital_id, :share_count, :or_number, :amount, :recorder_id)
    end
  end
end
