class HrModuleController < ApplicationController 
  def index 
    @employees = User.all
  end 
end 