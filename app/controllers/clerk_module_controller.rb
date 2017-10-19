class ClerkModuleController < ApplicationController
  def index 
    @employee = current_user
  end 
end 