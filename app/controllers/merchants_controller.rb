class MerchantsController < ApplicationController
  def index
    @merchants = current_cooperative.merchants
  end
  def new
    @merchant = current_cooperative.merchants.build
  end
  def create
    @merchant = current_cooperative.merchants.create(merchant_params)
    if @merchant.valid?
      @merchant.save!
      redirect_to merchants_url, notice: "Merchant saved successfully."
    else
      render :new
    end
  end

  private
  def merchant_params
    params.require(:merchant).
    permit(:name, :liability_account_id)
  end 
end
