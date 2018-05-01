module TimeDeposits
  class EarnedInterestsController < ApplicationController
    def new
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @earned_interest = TimeDeposits::EarnedInterestProcessing.new
    end
    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @earned_interest = TimeDeposits::EarnedInterestProcessing.new(earned_interest_params)
      if @earned_interest.valid?
        @earned_interest.process!
        redirect_to time_deposit_url(@time_deposit), notice: "Earned interest saved successfully"
      else
        render :new
      end
    end
    private
    def earned_interest_params
      params.require(:time_deposits_earned_interest_processing).
      permit(:or_number, :date, :time_deposit_id, :recorder_id, :amount)
    end
  end
end
