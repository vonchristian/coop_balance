class CustomerRegistrationsController < ApplicationController
  def new 
    @customer = Member.new 
  end 
  def create 
    @customer = Member.create(customer_params)
  end 
  private 
  def customer_params
    params.require(:member).permit(:first_name, :last_name, :contact_number)
  end 
end 