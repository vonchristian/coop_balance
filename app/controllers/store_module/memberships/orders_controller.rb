module StoreModule
  module Memberships
    class OrdersController < ApplicationController
      def new
         @cart = current_cart
      @order = StoreModule::Order.new
        @membership = Membership.find(params[:membership_id])
      end
    end
  end
end
