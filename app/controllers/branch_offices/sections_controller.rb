module BranchOffices
  class SectionsController < ApplicationController
    def new
      @branch_office = CoopConfigurationsModule::BranchOffice.find(params[:branch_office_id])
      @section = @branch_office.sections.build
    end
    def create
      @branch_office = CoopConfigurationsModule::BranchOffice.find(params[:branch_office_id])
      @section = @branch_office.sections.create(section_params)
      if @section.save
        redirect_to branch_office_url(@branch_office), notice: "Section created successfully."
      else
        render :new
      end
    end

    private
    def section_params
      params.require(:coop_configurations_module_section).permit(:name, :description)
    end
  end
end
