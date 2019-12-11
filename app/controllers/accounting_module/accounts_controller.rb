module AccountingModule
  class AccountsController < ApplicationController
    respond_to :html, :json
    before_action :set_type
    before_action :set_account, only: [:edit, :update]

    def index
      if params[:search].present?
        @accounts = type_class.text_search(params[:search]).order(:code).paginate(:page => params[:page], :per_page => 30)
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
      ActiveRecord::Base.transaction do
        @account = current_cooperative.accounts.create(account_params)
        current_office.accounts.create(account_params)
      end
      authorize [:accounting_module, :account]
      respond_modal_with @account,
        location: accounting_module_accounts_url
    end

    def show
      @account = current_cooperative.accounts.find(params[:id])
    end

    def edit
      @account = current_cooperative.accounts.find(params[:id])
    end

    def update
      @account = current_cooperative.accounts.find(params[:id])
      @account.update(update_params)
      if @account.valid?
        @account.save!
        redirect_to accounting_module_account_settings_url(@account), notice: 'Account updated successfully.'
      else
        render :edit
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
      current_cooperative.accounts.types.include?(params[:type]) ? params[:type] : "AccountingModule::Account"
    end

    def type_class
      type.constantize
    end

    def account_params
      params.require(:accounting_module_account).permit(:name, :code, :type, :contra, :main_account_id)
    end
    def update_params
      params.require(@account.type.underscore.parameterize.underscore.to_sym).permit(:name, :code, :type, :contra, :level_one_account_category_id)
    end
  end
end
