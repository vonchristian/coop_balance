module Members 
  class InfoController < ApplicationController
    def index 
      @member = Member.friendly.find(params[:member_id])
      respond_to do |format| 
        format.html 
        format.pdf do 
          pdf = Members::ReportPdf.new(@member, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Member Report.pdf"
        end 
      end 
    end 
  end 
end 