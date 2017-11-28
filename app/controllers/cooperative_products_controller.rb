class CooperativeProductsController < ApplicationController
  def index
    @saving_products = CoopServicesModule::SavingProduct.all
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CooperativeReports::ProductsReportPdf.new(@saving_products, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Cooperative Product Report.pdf"
      end
    end
  end
end
