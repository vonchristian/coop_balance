module Customers
  class OrdersController < ApplicationController
    def index
      if Member.find_by_id(params[:customer_id]).present?
        @customer = Member.find_by_id(params[:customer_id])
      elsif User.find_by_id(params[:customer_id]).present?
        @customer = User.find_by_id(params[:customer_id])
      end
      @orders = @customer.orders.order(date: :desc).paginate(page: params[:page], per_page: 50)
    end
  end
end
