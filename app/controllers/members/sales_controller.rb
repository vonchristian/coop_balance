module Members
  class SalesController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @sales = @member.sales
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::SalesOrdersPdf.new(@member, view_context)
          send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Members Purchases.pdf'
        end
      end
    end
  end
end
