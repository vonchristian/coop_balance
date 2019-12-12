module Offices
  class SavingProductsController < ApplicationController
    def index
      @saving_products = current_office.saving_products
    end

    def new
      @saving_product = current_office.office_saving_products.build
    end

    def create
      @saving_product = current_office.office_saving_products.create(saving_product_params)
      if @saving_product.valid?
        @saving_product.save!
        redirect_to office_saving_products_url(current_office), notice: 'Saving product saved successfully.'
      else
        render :new
      end
    end

    private

    def saving_product_params
      params.require(:offices_office_saving_product).
      permit(:saving_product_id, :liability_account_category_id, :interest_expense_account_category_id, :closing_account_category_id, :forwarding_account_id)
    end
  end
end