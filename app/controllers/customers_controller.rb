require 'will_paginate/array'
class CustomersController < ApplicationController
  def index
    customers = Member.all + User.all
    @customers = customers.paginate(page: params[:page], per_page: 50)
  end
end
