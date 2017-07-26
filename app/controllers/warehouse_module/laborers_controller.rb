module WarehouseDepartment
  class LaborersController < ApplicationController
    def index
      @laborers = Laborer.all
    end
    def new
      @laborer = Laborer.new
    end
    def create
      @laborer = Laborer.create(laborer_params)
      if @laborer.valid?
        @laborer.save
        redirect_to warehouse_department_laborers_url, notice: "Success"
      else
        render :new
      end
    end
    def show
      @laborer = Laborer.find(params[:id])
    end

    private
    def laborer_params
      params.require(:laborer).permit(:first_name, :last_name)
    end
  end
end
