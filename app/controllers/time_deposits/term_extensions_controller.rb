module TimeDeposits
  class TermExtensionsController < ApplicationController
    respond_to :html, :json

    def new
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @renewal      = TimeDeposits::TermExtension.new
      respond_modal_with @renewal
    end

    def create
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @renewal     = TimeDeposits::TermExtension.new(term_params)
      @renewal.save
      respond_modal_with @renewal,
        location: time_deposit_settings_url(@time_deposit),
        notice: "Time Deposit term saved successfully."
    end

    private
    def term_params
      params.require(:time_deposits_term_extension).permit(:time_deposit_id, :recorder_id, :term, :renewal_date)
    end
  end
end
