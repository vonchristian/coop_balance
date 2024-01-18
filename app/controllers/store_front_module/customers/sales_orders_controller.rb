module StoreFrontModule
  module Customers
    class SalesOrdersController < ApplicationController
      def index
        if Member.find_by(id: params[:customer_id]).present?
          @customer = Member.find_by(id: params[:customer_id])
        elsif User.find_by(id: params[:customer_id]).present?
          @customer = User.find_by(id: params[:customer_id])
        end
        @sales_orders = @customer.sales_orders.paginate(page: params[:page], per_page: 30)
      end
    end
  end
end
