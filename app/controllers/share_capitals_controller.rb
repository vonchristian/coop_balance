require 'will_paginate/array'
class ShareCapitalsController < ApplicationController
  def index
    if params[:from_date].present? && params[:to_date].present?
      @from_date = DateTime.parse(params[:from_date])
      @to_date = DateTime.parse(params[:to_date])
      @share_capitals = current_cooperative.share_capitals.inactive(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 20)
    elsif params[:search].present?
      @share_capitals = current_cooperative.share_capitals.text_search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    else
      @share_capitals = current_cooperative.share_capitals.includes([:subscriber, :share_capital_product =>[:paid_up_account]]).order(:account_owner_name).all.paginate(:page => params[:page], :per_page => 20)
    end
  end

  def show
    @employee = current_user
    @share_capital = current_cooperative.share_capitals.find(params[:id])
    @entries = @share_capital.entries.sort_by(&:entry_date).reverse.paginate(page: params[:page], per_page: 25)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ShareCapitals::StatementOfAccountPdf.new(
        share_capital: @share_capital,
        view_context:    view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Statement of Account.pdf"
      end
    end
  end
end
