class RegistriesController < ApplicationController 
  def create 
    @registry = Registry.create(registry_params)
    if @registry.save 
      @registry.parse_for_records
      redirect_to admin_settings_url, notice: "Registry saved successfully"
    end 
  end 

  private 
  def registry_params
    params.require(:registry).permit(:spreadsheet)
  end
end 