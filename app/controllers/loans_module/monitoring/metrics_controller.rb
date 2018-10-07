module LoansModule
  module Monitoring
    class MetricsController < ApplicationController
      def index
        @loans = LoansModule::Loan.disbursed
      end
    end
  end
end
