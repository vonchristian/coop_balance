module HrModule 
  class PayrollsController < ApplicationController
    def index 
      @employee = User.find(params[:employee_id])
    end 
  end 
end 