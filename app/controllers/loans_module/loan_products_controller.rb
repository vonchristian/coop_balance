module LoansDepartment
  class LoanProductsController < ApplicationController
    def index
      @loan_products = LoansDepartment::LoanProduct.all
    end
    def new
      @loan_product = LoansDepartment::LoanProductForm.new(LoansDepartment::LoanProduct.new)
    end
    def create
      @loan_product = LoansDepartment::LoanProductForm.new(LoansDepartment::LoanProduct.new)
      if @loan_product.validate(params[:loans_department_loan_product])
        @loan_product.save
        redirect_to loans_department_loan_products_url, notice: "Loan Product created successfully."
      else
        render :new
      end
    end
  end
end
