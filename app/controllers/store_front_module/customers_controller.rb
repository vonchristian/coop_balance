require 'will_paginate/array'
module StoreFrontModule
  class CustomersController < ApplicationController
    def index
      if params[:search].present?
        member_customers = Member.text_search(params[:search])
        employee_customers = User.text_search(params[:search])
        customers = member_customers + employee_customers
        @customers =customers.paginate(page: params[:page], per_page: 50)
      else
        customers = Member.all + User.all
        @customers = customers.paginate(page: params[:page], per_page: 50)
      end
    end
    def show
      if Member.find_by_id(params[:id]).present?
        @customer = Member.find_by_id(params[:id])
      elsif User.find_by_id(params[:id]).present?
        @customer = User.find_by_id(params[:id])
      end
    end
  end
end
