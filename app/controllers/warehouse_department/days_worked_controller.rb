module WarehouseDepartment
  class DaysWorkedController < ApplicationController
    def new
      @laborer = Laborer.find(params[:laborer_id])
      @days_worked = @laborer.days_worked.build
    end
    def create
      @laborer = Laborer.find(params[:laborer_id])
      @days_worked = @laborer.days_worked.build(days_worked_params)
      if @days_worked.valid?
        @days_worked.save
        redirect_to warehouse_department_laborer_url(@laborer), notice: "Success"
      else
        render :new
      end
    end

    private
    def days_worked_params
      params.require(:days_worked).permit(:number_of_days)
    end
  end
end 
