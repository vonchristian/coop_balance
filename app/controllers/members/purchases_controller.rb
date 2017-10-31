module Members
  class PurchasesController < ApplicationController
    def index
      @member = Member.friendly.find(params[:member_id])
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::PurchasesPdf.new(@member, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Members Purchases.pdf"
        end
      end
    end
  end
end
