class ProgramsController < ApplicationController
  def index
    @programs = current_cooperative.programs
  end

  def show
    @program = current_cooperative.programs.find(params[:id])
  end
end
