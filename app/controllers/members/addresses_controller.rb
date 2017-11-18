module Members
  class AddressesController < ApplicationController
    def edit
      @member = Member.friendly.find(params[:member_id])
      @address = @member.addresses.build
    end
    def update
      @member = Member.frienly.find(params[:member_id])
      @address = @member.addresses.create(address_params)
      if @member.save
        redirect_to member_url(@member), notice: "Address updated successfully"
      else
        render :edit
      end
    end

    private
    def address_params
      params.require(:address).permit(:barangay_id, :municipality_id, :street)
    end
  end
end
