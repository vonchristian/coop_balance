class SavingsAccountsController < ApplicationController
  def index
    if params[:search].present?
      @savings_accounts = MembershipsModule::Saving.text_search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    else 
      @savings_accounts = MembershipsModule::Saving.includes([:member, :saving_product, :entries]).order(:account_owner_name).all.paginate(:page => params[:page], :per_page => 20)
    end
  end
  
  def show 
    @savings_account = MembershipsModule::Saving.includes(entries: :recorder).find(params[:id])
  end
end
