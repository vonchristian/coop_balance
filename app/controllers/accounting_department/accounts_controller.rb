module AccountingDepartment
  class AccountsController < ApplicationController
    def index
      @accounts = AccountingDepartment::Account.all.order(:code)
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

    private
    def account_params
      params.require(:accounting_department_account).permit(:name, :code, :type, :contra)
    end
  end
end
