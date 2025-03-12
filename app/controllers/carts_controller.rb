class CartsController < ApplicationController
  def destroy
    @cart = StoreFrontModule::Cart.find(params[:id])
    @cart.destroy
    redirect_to loans_path, notice: "cancelled successfully"
  end
end
