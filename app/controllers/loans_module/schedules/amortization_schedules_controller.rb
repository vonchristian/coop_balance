module LoansModule
  module Schedules
    class AmortizationSchedulesController < ApplicationController
      def show
        @amortization_schedule = current_cooperative.amortization_schedules.find(params[:id])
      end
    end
  end
end
