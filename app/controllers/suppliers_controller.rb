class SuppliersController < ApplicationController 
  def index 
    @suppliers = Supplier.all.paginate(:page => params[:page], :per_page => 50) 
  end 
  def new 
    @supplier = Supplier.new 
  end 
  def create 
    @supplier = Supplier.create(supplier_params)
  end

  private 
  def supplier_params
    params.require(:supplier).permit(:first_name, :last_name, :contact_number, :business_name, :address)
  end
end 