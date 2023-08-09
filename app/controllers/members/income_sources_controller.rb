module Members 
  class IncomeSourcesController < ApplicationController
    def new 
      @member        = current_office.member_memberships.find(params[:member_id])
      @income_source = @member.income_sources.build 
    end 

    def create
      @member        = current_office.member_memberships.find(params[:member_id])
      @income_source = @member.income_sources.create(income_source_params)
      if @income_source.valid?
        @income_source.save!
        redirect_to member_settings_path(@member), notice: 'Income Source saved successfully'
      else 
        render :new, status: :unprocessable_entity
      end  
    end 

    private 
    def income_source_params
      params.require(:memberships_module_income_source).
      permit(:designation, :description, :income_source_category_id)
    end 
  end 
end 