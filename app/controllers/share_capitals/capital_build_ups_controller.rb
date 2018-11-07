module ShareCapitals
  class CapitalBuildUpsController < ApplicationController
    def new
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @capital_build_up = Memberships::ShareCapitals::CapitalBuildUpProcessing.new
      authorize [:share_capitals, :capital_build_up]
    end

    def create
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @capital_build_up = Memberships::ShareCapitals::CapitalBuildUpProcessing.new(share_capital_params)
      authorize [:share_capitals, :capital_build_up]
      if @capital_build_up.valid?
        @capital_build_up.save
        redirect_to share_capital_voucher_url(share_capital_id: @share_capital.id, id: @capital_build_up.find_voucher.id), notice: "Capital build up saved successfully."
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:memberships_share_capitals_capital_build_up_processing).permit(:share_capital_id, :or_number, :date, :amount, :employee_id, :depositor_id, :cash_account_id, :account_number)
    end
  end
end
