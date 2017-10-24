class ShareCapitalsController < ApplicationController
  def index
    if params[:search].present?
      @share_capitals = MembershipsModule::ShareCapital.text_search(params[:search]).paginate(page: params[:page], per_page: 30)
    else
      @share_capitals = MembershipsModule::ShareCapital.all.paginate(page: params[:page], per_page: 30)
    end
  end
  def show 
    @employee = current_user
    @share_capital = MembershipsModule::ShareCapital.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = ShareCapitalPdf.new(@share_capital, @employee, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Share Capital PDF.pdf"
      end
    end
  end
end
