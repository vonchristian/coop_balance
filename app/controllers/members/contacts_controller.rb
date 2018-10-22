module Members
  class ContactsController < ApplicationController
    respond_to :html, :json

    def new
      @member = Member.find(params[:member_id])
      @contact = @member.contacts.build
      respond_modal_with @contact
    end

    def create
      @member = Member.find(params[:member_id])
      @contact = @member.contacts.create(contact_params)
      respond_modal_with @contact, location: member_info_index_url(@member), notice: "Contact Number updated successfully"
    end

    private
    def contact_params
      params.require(:contact).permit(:number)
    end
  end
end
