module Offices
  class ShareCapitalProductsController < ApplicationController

    def index
    end

    def new
      @share_capital_product = current_office.office_share_capital_products.build
    end

    def create
      @share_capital_product = current_office.office_share_capital_products.create(share_capital_product_params)
      if @share_capital_product.valid?
        @share_capital_product.save!
        redirect_to office_share_capital_products_url(current_office), notice: 'Share Capital Product saved successfully.'
      else
        render :new
      end
    end

    private

    def share_capital_product_params
      params.require(:offices_office_share_capital_product).
      permit(:share_capital_product_id, :equity_account_category_id, :forwarding_account_id)
    end
  end
end
