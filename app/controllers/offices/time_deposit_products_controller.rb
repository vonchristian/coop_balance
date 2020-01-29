module Offices
  class TimeDepositProductsController < ApplicationController
    def index
      @time_deposit_products = current_office.time_deposit_products 
    end
    def new
      @time_deposit_product = current_office.office_time_deposit_products.build
    end
    def create
      @time_deposit_product = current_office.office_time_deposit_products.create(time_deposit_product_params)
      if @time_deposit_product.valid?
        @time_deposit_product.save!
        redirect_to office_time_deposit_products_url(current_office), notice: 'Time Deposit Product saved successfully.'
      else
        render :new
      end
    end

    private
    def time_deposit_product_params
      params.require(:offices_office_time_deposit_product).
      permit(:time_deposit_product_id, :liability_account_category_id, :interest_expense_account_category_id, :break_contract_account_category_id, :forwarding_account_id)
    end 
  end
end
