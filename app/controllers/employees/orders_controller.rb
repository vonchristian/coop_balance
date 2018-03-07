module Employees
  class OrdersController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @orders = @employee.purchases.order(date: :desc).all.paginate(page: params[:page], per_page: 35)
    end
  end
end
