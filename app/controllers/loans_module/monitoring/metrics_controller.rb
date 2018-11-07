module LoansModule
  module Monitoring
    class MetricsController < ApplicationController
      def index
        @loans = current_cooperative.loans.disbursed
      end
    end
  end
end
