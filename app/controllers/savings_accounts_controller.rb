require 'will_paginate/array'
class SavingsAccountsController < ApplicationController
  def index
    if params[:search].present?
      @pagy, @savings_accounts = pagy(current_office.savings.includes(:office,[:saving_product =>[:account], :depositor => [:avatar_attachment => [:blob]]]).text_search(params[:search]))
    else
      @pagy, @savings_accounts = pagy(current_office.savings.includes(:office,[:saving_product =>[:account], :depositor => [:avatar_attachment => [:blob]]]).order(:account_owner_name))
    end
    @offices = current_cooperative.offices
  end

  def show
    @savings_account = current_office.savings.includes(:saving_product => [:account]).find(params[:id])
    @pagy, @entries  = pagy(@savings_account.entries.includes(:recorder).order(entry_date: :desc))
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
