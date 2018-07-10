module Members
  class ContactsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @contact = @member.contacts.build
    end
    def create
      @member = Member.find(params[:member_id])
      @contact = @member.contacts.create(contact_params)
      if @contact.valid?
        @contact.save
        redirect_to member_info_index_url(@member), notice: "Contact info updated successfully."
      else
        render :new
      end
    end

    private
    def contact_params
      params.require(:contact).permit(:number)
    end
  end
end
