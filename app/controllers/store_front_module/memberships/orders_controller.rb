module StoreFrontModule
  module Memberships
    class OrdersController < ApplicationController
      def new
        @cart = current_cart
        @order = StoreFrontModule::Order.new
        @membership = Membership.find(params[:membership_id])
      end
    end
  end
end
