module LoansModule
  module Schedules
    class AmortizationSchedulesController < ApplicationController
      def show
        @amortization_schedule = LoansModule::AmortizationSchedule.find(params[:id])
      end
    end
  end
end
