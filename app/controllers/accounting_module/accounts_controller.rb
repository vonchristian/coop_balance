module AccountingModule
  class AccountsController < ApplicationController
    def index
      if params[:search].present?
        @accounts = AccountingModule::Account.text_search(params[:search]).page(params[:page]).per(50)
      else 
        @accounts = AccountingModule::Account.all.order(:code).page(params[:page]).per(50)
      end
    end
    def new
      @account = AccountingModule::Account.new
    end
    def create
      @account = AccountingModule::Account.create(account_params)
      if @account.valid?
        @account.save
        redirect_to accounting_module_accounts_url, notice: "Account created successfully."
      else
        render :new
      end
    end
    def show 
      @account = AccountingModule::Account.find(params[:id])
    end

    private
    def account_params
      params.require(:accounting_module_account).permit(:name, :code, :type, :contra)
    end
  end
end
