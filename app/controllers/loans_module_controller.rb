class LoansModuleController < ApplicationController
  def index
    @loan_products = current_cooperative.loan_products
  end
end
