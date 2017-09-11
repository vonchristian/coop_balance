module LoansModule 
  class NoticesController < ApplicationController
    def index 
      @notices = Notice.all 
    end
    def show 
      @notice = Notice.find(params[:id])
      respond_to do |format| 
        format.html 
        format.pdf do 
          pdf = LoansModule::NoticePdf.new(@notice, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Notice.pdf"
        end
      end
    end 
  end
end