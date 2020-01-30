module Offices 
  class NetIncomeConfigsController < ApplicationController
    def index 
      @office = current_cooperative.offices.find(params[:office_id])
      @net_income_configs = @office.net_income_configs 
    end 

    def new 
      @office            = current_cooperative.offices.find(params[:office_id])
      @net_income_config = @office.net_income_configs.build 
    end
    
    def create 
      @office            = current_cooperative.offices.find(params[:office_id])
      @net_income_config = @office.net_income_configs.create(net_income_config_params)
      if @net_income_config.valid?
        @net_income_config.save!
        redirect_to office_net_income_configs_url(@office), notice: 'Net Income Configuration saved successfully'
      else 
        render :new 
      end  
    end

    private 
    def net_income_config_params
      params.require(:offices_net_income_config).
      permit(:book_closing, :net_surplus_account_id, :net_loss_account_id)
    end 
  end 
end 
      