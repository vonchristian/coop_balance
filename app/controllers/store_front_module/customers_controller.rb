require "will_paginate/array"
module StoreFrontModule
  class CustomersController < ApplicationController
    def index
      @customers = if params[:search].present?
                     Customer.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
                     Customer.all.paginate(page: params[:page], per_page: 25)
      end
    end

    def show
      if Member.find_by(id: params[:id]).present?
        @customer = Member.find_by(id: params[:id])
      elsif User.find_by(id: params[:id]).present?
        @customer = User.find_by(id: params[:id])
      end
    end
  end
end
