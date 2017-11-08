module StoreModule
  class AccountsReceivableStoreConfigController < ApplicationController
    def new
      @accounts_receivable_store_config = CoopConfigurationsModule::AccountReceivableStoreConfig.new
    end
    def create
      @accounts_receivable_store_config = CoopConfigurationsModule::AccountReceivableStoreConfig.create(config_params)
      if @accounts_receivable_store_config.save
      redirect_to store_module_settings_url, notice: "Settings saved successfully."
      else
      render :new
      end
    end

    private
    def config_params
      params.require(:coop_configurations_module_account_receivable_store_config).permit(:account_id)
    end
  end
end
