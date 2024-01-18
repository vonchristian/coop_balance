module Offices
  class ProgramsController < ApplicationController
    def index; end

    def new
      @office_program = current_office.office_programs.build
    end

    def create
      @office_program = current_office.office_programs.create(program_params)
      if @office_program.valid?
        @office_program.save!
        redirect_to office_programs_url(current_office), notice: 'Program created successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def program_params
      params.require(:offices_office_program)
            .permit(:program_id, :ledger_id)
    end
  end
end
