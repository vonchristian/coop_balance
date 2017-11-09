module LoansModule
  module Reports
    class LoanReleasesController < ApplicationController
      def index
        @loan_releases = LoansModule::Loan.disbursed
      end
    end
  end
end
