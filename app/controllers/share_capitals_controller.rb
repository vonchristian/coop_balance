require 'will_paginate/array'
class ShareCapitalsController < ApplicationController
  def index
    @office = params[:office_id] ? current_cooperative.offices.find_by(id: params[:office_id]) : current_office
    if params[:search].present?
      @share_capitals = @office.share_capitals.includes(:office, [:share_capital_product =>[:equity_account], :subscriber => [:avatar_attachment => [:blob]]]).text_search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    else
      @share_capitals = @office.share_capitals.includes(:office, [:share_capital_product =>[:equity_account], :subscriber => [:avatar_attachment => [:blob]]]).paginate(:page => params[:page], :per_page => 20)
    end
    @offices = current_cooperative.offices
    
  end

  def show
    @employee = current_user
    @share_capital = current_cooperative.share_capitals.find(params[:id])
    @entries = @share_capital.entries.includes(:commercial_document, :recorder, :cooperative_service).sort_by(&:entry_date).reverse.paginate(page: params[:page], per_page: 25)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StatementOfAccounts::ShareCapitalPdf.new(
        share_capital: @share_capital,
        view_context:    view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Statement of Account.pdf"
      end
    end
  end
end
