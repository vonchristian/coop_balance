require 'will_paginate/array'
class ShareCapitalsController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @share_capitals = pagy(current_office.share_capitals.includes(:office, [:share_capital_product =>[:equity_account], :subscriber => [:avatar_attachment => [:blob]]]).text_search(params[:search]))
    else
      @pagy, @share_capitals = pagy(current_office.share_capitals.includes(:office, [:share_capital_product =>[:equity_account], :subscriber => [:avatar_attachment => [:blob]]]))
    end
    @offices = current_cooperative.offices

  end

  def show
    @employee = current_user
    @share_capital = current_office.share_capitals.find(params[:id])
    @entries = @share_capital.entries.order(entry_date: :desc).includes(:commercial_document, :recorder, :cooperative_service).paginate(page: params[:page], per_page: 25)
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
