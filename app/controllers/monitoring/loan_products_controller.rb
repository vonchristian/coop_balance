module Monitoring
  class LoanProductsController < ApplicationController
    def index
      @loan_products = LoansModule::LoanProduct.all
    end
  end
end
