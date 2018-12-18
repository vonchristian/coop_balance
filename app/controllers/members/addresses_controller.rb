module Members
  class AddressesController < ApplicationController
    respond_to :html, :json

    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @address = @member.addresses.build
      respond_modal_with @address
    end

    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @address = @member.addresses.create(address_params)
      respond_modal_with @address, location: member_info_index_url(@member)
    end

    private
    def address_params
      params.require(:address).permit(:complete_address, :street_id, :barangay_id, :municipality_id, :province_id, :current)
    end
  end
end
