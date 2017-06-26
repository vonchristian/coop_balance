module ManagementDepartment
  class AccountsController < ApplicationController
    def index
      if params[:search].present?
        @accounts = AccountingDepartment::Account.text_search(params[:search]).page(params[:page]).per(50)
      else 
        @accounts = AccountingDepartment::Account.all.order(:code).page(params[:page]).per(50)
      end
    end
    def new
      @account = AccountingDepartment::Account.new
    end
    def create
      @account = AccountingDepartment::Account.create(account_params)
      if @account.valid?
        @account.save
        redirect_to accounting_department_accounts_url, notice: "Account created successfully."
      else
        render :new
      end
    end
    def show 
      @account = AccountingDepartment::Account.find(params[:id])
    end

    private
    def account_params
      params.require(:accounting_department_account).permit(:name, :code, :type, :contra)
    end
  end
end
