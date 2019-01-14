module AccountingModule
  class AccountsController < ApplicationController
    respond_to :html, :json
    before_action :set_type
    before_action :set_account, only: [:edit, :update]

    def index
      if params[:search].present?
        @accounts = type_class.text_search(params[:search]).paginate(:page => params[:page], :per_page => 30)
      else
        @accounts = type_class.all.active.order(:code).paginate(:page => params[:page], :per_page => 30)
      end
    end

    def new
      @account = current_cooperative.accounts.new
      respond_modal_with @account
      authorize [:accounting_module, :account]
    end

    def create
      @account = current_cooperative.accounts.create(account_params)
      authorize [:accounting_module, :account]
      respond_modal_with @account,
        location: accounting_module_accounts_url
    end

    def show
      @account = current_cooperative.accounts.find(params[:id])
    end

    def edit
      @account = type_class.find(params[:id])
      respond_modal_with @account
    end

    def update
      @account = current_cooperative.accounts.find(params[:id])
      @account.update(account_params)
      respond_modal_with @account,
        location: accounting_module_account_url(@account)
    end

    private
    def set_type
       @type = type
    end

    def set_account
      @account = type_class.find(params[:id])
    end

    def type
        current_cooperative.accounts.types.include?(params[:type]) ? params[:type] : "AccountingModule::Account"
    end

    def type_class
      type.constantize
    end
    
    def account_params
      if @account && @account.type == "AccountingModule::Asset"
        params.require(:accounting_module_asset).permit(:name, :code, :type, :contra, :main_account_id)
      elsif @account && @account.type == "AccountingModule::Equity"
        params.require(:accounting_module_equity).permit(:name, :code, :type, :contra, :main_account_id)
      elsif @account &&  @account.type == "AccountingModule::Liability"
        params.require(:accounting_module_liability).permit(:name, :code, :type, :contra, :main_account_id)
      elsif  @account &&  @account.type == "AccountingModule::Revenue"
        params.require(:accounting_module_revenue).permit(:name, :code, :type, :contra, :main_account_id)
      elsif  @account &&  @account.type == "AccountingModule::Expense"
        params.require(:accounting_module_expense).permit(:name, :code, :type, :contra, :main_account_id)
      else
        params.require(:accounting_module_account).permit(:name, :code, :type, :contra, :main_account_id)

      end
    end
  end
end
