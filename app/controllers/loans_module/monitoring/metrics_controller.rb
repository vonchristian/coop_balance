module LoansModule
  module Monitoring
    class MetricsController < ApplicationController
      def index
        @loans = LoansModule::Loan.disbursed.not_archived.includes( :loan_product => [:loans_receivable_current_account] )
      end
    end
  end
end
