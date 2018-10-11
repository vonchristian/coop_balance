module AccountingModule
  class AccountsController < ApplicationController
    before_action :set_type
    before_action :set_account, only: [:edit, :update]
    def index
      if params[:search].present?
        @accounts = type_class.text_search(params[:search]).paginate(:page => params[:page], :per_page => 30)
      else
        @accounts = type_class.all.order(:code).paginate(:page => params[:page], :per_page => 30)
      end
    end
    def new
      @account = AccountingModule::Account.new
      authorize [:accounting_module, :account]
    end
    def create
      @account = AccountingModule::Account.create(account_params)
      authorize [:accounting_module, :account]
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
    def edit
      @account = type_class.find(params[:id])
    end
    def update
      @account = AccountingModule::Account.find(params[:id])
      @account.update(account_params)
      if @account.save
        redirect_to accounting_module_account_url(@account), notice: "Account details updated successfully."
      else
        render :new
      end
    end

    private
    def set_type
       @type = type
    end
    def set_account
      @account = type_class.find(params[:id])
    end

    def type
        AccountingModule::Account.types.include?(params[:type]) ? params[:type] : "AccountingModule::Account"
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
