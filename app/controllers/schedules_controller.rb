class SchedulesController < ApplicationController 
  def show 
    @schedule = LoansModule::AmortizationSchedule.find(params[:id])
    respond_to do |format|
      format.html 
      format.pdf do 
      end 
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  end 
end 