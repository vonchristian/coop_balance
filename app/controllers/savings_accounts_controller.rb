require 'will_paginate/array'
class SavingsAccountsController < ApplicationController
  def index
    if params[:from_date].present? && params[:to_date].present?
      @from_date = DateTime.parse(params[:from_date])
      @to_date = DateTime.parse(params[:to_date])
      @savings_accounts = MembershipsModule::Saving.inactive(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 20)
    elsif params[:search].present?
      @savings_accounts = MembershipsModule::Saving.text_search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    else
      @pagy, @savings_accounts = pagy(MembershipsModule::Saving.includes([:depositor, :saving_product =>[:account, :interest_expense_account]]).order(:account_owner_name).all)
    end
  end

  def show
    @savings_account = MembershipsModule::Saving.find(params[:id])
    @entries = @savings_account.entries.sort_by(&:entry_date).reverse.paginate(page: params[:page], per_page: 25)
  end
end
