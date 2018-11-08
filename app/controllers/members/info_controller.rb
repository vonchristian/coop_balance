module Members
  class InfoController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @cooperative = current_cooperative
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::ReportPdf.new(cooperative: @cooperative, member: @member, view_context: view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Member Report.pdf"
        end
      end
    end
  end
end
