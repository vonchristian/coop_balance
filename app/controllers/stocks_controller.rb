class StocksController < ApplicationController
  def new
    @product = StoreModule::Product.find(params[:product_id])
    @stock = @product.stocks.build
  end
  def create
    @product = StoreModule::Product.find(params[:product_id])
    @stock = @product.stocks.build(stock_params)
    if @stock.valid?
      @stock.save
      redirect_to product_path(@product), notice: "Stock saved successfully"
    else
      render :new
    end
  end

  private
  def stock_params
    params.require(:store_module_product_stock).permit(:supplier_id, :date, :quantity, :unit_cost, :total_cost, :barcode)
  end
end
