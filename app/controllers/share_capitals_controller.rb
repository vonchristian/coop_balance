require "will_paginate/array"
class ShareCapitalsController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @share_capitals = pagy(current_office.share_capitals.includes(:share_capital_product, :share_capital_equity_account, subscriber: [ avatar_attachment: [ :blob ] ]).text_search(params[:search]))
    else
      @pagy, @share_capitals = pagy(current_office.share_capitals.includes(:share_capital_product, :share_capital_equity_account, subscriber: [ avatar_attachment: [ :blob ] ]))
    end
    @offices = current_cooperative.offices
  end

  def show
    @share_capital = current_office.share_capitals.find(params[:id])
    if params[:search].present?
      @pagy, @entries = pagy(@share_capital.entries.includes(:recorder, :office).order(entry_date: :desc).order(entry_time: :desc).text_search(params[:search]))
    else
      @pagy, @entries = pagy(@share_capital.entries.includes(:recorder, :office).order(entry_date: :desc).order(entry_time: :desc))
    end
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StatementOfAccounts::ShareCapitalPdf.new(
          share_capital: @share_capital,
          view_context: view_context
        )
        send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Statement of Account.pdf"
      end
    end
  end
end
