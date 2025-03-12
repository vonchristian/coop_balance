module Monitoring
  class SavingsProductsController < ApplicationController
    def index
      @saving_products = current_cooperative.saving_products
      respond_to do |format|
        format.html
        format.pdf do
          pdf = CooperativeProducts::SavingsProductsPdf.new(@saving_products, view_context)
          send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Cooperative Product Report.pdf"
        end
      end
    end
  end
end
