class LoansDepartmentController < ApplicationController
  def index
    @loan_products = LoansDepartment::LoanProduct.all
  end
end
