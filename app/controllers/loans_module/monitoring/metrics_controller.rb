module LoansModule
  module Monitoring
    class MetricsController < ApplicationController
      def index
        @loans = current_office.loans
      end
    end
  end
end
