require 'will_paginate/array'
class ShareCapitalsController < ApplicationController
  def index
    @metric = CoopServicesModule::ShareCapitalProduct.metric
    if params[:search].present?
      @share_capitals = MembershipsModule::ShareCapital.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @share_capitals = MembershipsModule::ShareCapital.includes(:subscriber, :share_capital_product).all.paginate(page: params[:page], per_page: 25)
    end
  end
  def show
    @employee = current_user
    @share_capital = MembershipsModule::ShareCapital.find(params[:id])
    @entries = @share_capital.capital_build_ups.sort_by(&:entry_date).reverse.paginate(page: params[:page], per_page: 25)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ShareCapitalPdf.new(@share_capital, @employee, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Share Capital PDF.pdf"
      end
    end
  end
end
