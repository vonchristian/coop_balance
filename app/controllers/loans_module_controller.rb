class LoansModuleController < ApplicationController
  def index
    @loan_products = LoansModule::LoanProduct.all
  end
end
