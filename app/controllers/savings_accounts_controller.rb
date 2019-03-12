require 'will_paginate/array'
class SavingsAccountsController < ApplicationController
  def index
    if params[:search].present?
      @savings_accounts = current_cooperative.savings.includes(:office,[:saving_product =>[:account], :depositor => [:avatar_attachment => [:blob]]]).text_search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    else
      @savings_accounts = current_office.savings.includes(:office,[:saving_product =>[:account], :depositor => [:avatar_attachment => [:blob]]]).order(:account_owner_name).paginate(:page => params[:page], :per_page => 20)
    end
    @offices = current_cooperative.offices
  end

  def show
    @savings_account = current_cooperative.savings.includes(:saving_product => [:account]).find(params[:id])
    @entries = @savings_account.entries.includes(:commercial_document, :recorder, :cooperative_service).distinct
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StatementOfAccounts::SavingsAccountPdf.new(
        savings_account: @savings_account,
        view_context:    view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Statement of Account.pdf"
      end
    end
  end
end
