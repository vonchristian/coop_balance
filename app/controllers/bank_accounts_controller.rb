require 'will_paginate/array'
class BankAccountsController < ApplicationController
  def index
    if params[:search].present?
      @bank_accounts = current_cooperative.bank_accounts.text_search(params[:search])
    else
      @bank_accounts = current_cooperative.bank_accounts.paginate(page: params[:page], per_page: 25)
    end
  end

  def new
    @bank_account = BankAccounts::Opening.new
  end
  def create
    @bank_account = BankAccounts::Opening.new(bank_account_params)
    if @bank_account.valid?
      @bank_account.process!
      redirect_to bank_accounts_url, notice: "Bank account details saved successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end
  def show
    @bank_account = current_cooperative.bank_accounts.find(params[:id])
    @entries = @bank_account.entries.order(entry_date: :desc).paginate(page: params[:page], per_page: 35)
  end

  private
  def bank_account_params
    params.require(:bank_accounts_opening).permit(:bank_name, :bank_address, :account_number, :amount, :recorder_id, :account_id, :earned_interest_account_id, :date, :reference_number, :description, :cash_account_id)
  end
end
