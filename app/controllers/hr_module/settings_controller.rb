module HrModule 
  class SettingsController < ApplicationController
    def index 
      authorize [:hr_module, :settings]
    end 
  end 
end 