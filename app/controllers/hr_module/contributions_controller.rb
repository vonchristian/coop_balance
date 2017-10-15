module HrModule 
  class ContributionsController < ApplicationController
    def new 
      @contribution = Contribution.new 
    end 
    def create 
      @contribution = Contribution.create(contribution_params)
      if @contribution.save 
        redirect_to hr_module_settings_url, notice: "Contribution created successfully"
      else 
        render :new 
      end 
    end 

    private 
    def contribution_params
      params.require(:contribution).permit(:name, :amount)
    end 
  end 
end 
