module TimeDeposits
  class TermExtensionsController < ApplicationController
    def new
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @renewal = TimeDeposits::TermExtension.new
    end
    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @renewal = TimeDeposits::TermExtension.new(term_params)
      if @renewal.valid?
        @renewal.save
        redirect_to time_deposit_url(@time_deposit), notice: "Time Deposit term saved successfully."
      else
        render :new
      end
    end

    private
    def term_params
      params.require(:time_deposits_term_extension).permit(:time_deposit_id, :recorder_id, :term, :renewal_date)
    end
  end
end
