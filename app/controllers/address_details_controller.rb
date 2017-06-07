class AddressDetailsController < ApplicationController
  def new
    @member = Member.find(params[:member_id])
    @address_details = AddressForm.new(@member)
    @address_details.prepopulate!
  end
  def create
    @member = Member.find(params[:member_id])
    @address_details = AddressForm.new(@member)
    if @address_details.validate(params[:address])
      @address_details.save
      redirect_to @member, notice: "Address saved successfully."
    else
      render :new
    end
  end
end 
