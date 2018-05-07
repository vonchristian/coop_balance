class ProgramsController < ApplicationController
  def index
    @programs = CoopServicesModule::Program.all
  end
  def show
    @program = CoopServicesModule::Program.find(params[:id])
  end
end
