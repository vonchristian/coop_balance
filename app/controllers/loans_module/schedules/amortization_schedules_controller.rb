module LoansModule
  module Schedules
    class AmortizationSchedulesController < ApplicationController
      def show
        @schedule = LoansModule::AmortizationSchedule.find(params[:id])
      end
    end
  end
end
