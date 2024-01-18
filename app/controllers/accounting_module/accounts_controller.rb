module AccountingModule
  class AccountsController < ApplicationController
    respond_to :html, :json
    before_action :set_type
    before_action :set_account, only: %i[edit update]

    def index
      @accounts = if params[:search].present?
                    type_class.text_search(params[:search]).order(:code).paginate(page: params[:page], per_page: 30)
                  else
                    type_class.all.active.order(:code).paginate(page: params[:page], per_page: 30)
                  end
    end

    def new
      @account = current_office.accounts.build
      authorize %i[accounting_module account]
    end

    def create
      @account = current_office.accounts.create(account_params)
      authorize %i[accounting_module account]
      if @account.valid?
        @account.save!
        redirect_to accounting_module_account_url(@account), notice: 'Account created successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @account = current_office.accounts.find(params[:id])
    end

    def edit
      @account = current_office.accounts.find(params[:id])
    end

    def update
      @account = current_office.accounts.find(params[:id])
      @account.update(update_params)
      if @account.valid?
        @account.save!
        redirect_to accounting_module_account_settings_url(@account), notice: 'Account updated successfully.'
      else
        render :edit, status: :unprocessable_entity
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
      current_cooperative.accounts.types.include?(params[:type]) ? params[:type] : 'AccountingModule::Account'
    end

    def type_class
      type.constantize
    end

    def account_params
      params.require(:accounting_module_account).permit(:name, :code, :type, :contra, :ledger_id)
    end

    def update_params
      params.require(@account.type.underscore.parameterize.underscore.to_sym).permit(:name, :code, :type, :contra, :ledger_id)
    end
  end
end
