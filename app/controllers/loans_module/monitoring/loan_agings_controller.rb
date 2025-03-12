module LoansModule
  module Monitoring
    class LoanAgingsController < ApplicationController
      def index
        @loan_aging_groups = current_office.loan_aging_groups.order(start_num: :asc)
      end
    end
  end
end
