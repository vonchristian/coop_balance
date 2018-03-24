require 'will_paginate/array'
module StoreFrontModule
  class CustomersController < ApplicationController
    def index
      if params[:search].present?
        @customers = Customer.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
        @customers = Customer.all.paginate(page: params[:page], per_page: 25)
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
