module Offices
  class LoanProductsController < ApplicationController
    def index
      @pagy, @loan_products = pagy(current_office.loan_products)
    end

    def new
      @loan_product = current_office.office_loan_products.build
    end

    def create
      @loan_product = current_office.office_loan_products.create(loan_product_params)
      if @loan_product.valid?
        @loan_product.save!
        redirect_to office_loan_products_url(current_office), notice: "Loan Product saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def loan_product_params
      params.require(:offices_office_loan_product)
            .permit(:loan_product_id, :interest_revenue_ledger_id, :penalty_revenue_ledger_id, :forwarding_account_id, :loan_protection_plan_provider_id)
    end
  end
end
