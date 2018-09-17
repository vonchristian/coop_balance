module Members
  class AddressesController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @address = @member.addresses.build
    end
    def create
      @member = Member.find(params[:member_id])
      @address = @member.addresses.create(address_params)
      if @member.save
        redirect_to member_info_index_url(@member), notice: "Address updated successfully"
      else
        render :new
      end
    end

    private
    def address_params
      params.require(:address).permit(:complete_address, :street_id, :barangay_id, :municipality_id, :province_id, :current)
    end
  end
end
