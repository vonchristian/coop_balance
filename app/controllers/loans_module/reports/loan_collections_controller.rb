module LoansModule
  module Reports
    class LoanCollectionsController < ApplicationController
      def index
        @accounts = LoansModule::LoanProduct.accounts
      end
    end
  end
end
