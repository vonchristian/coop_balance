require 'will_paginate/array'
module LoansModule
  class MemberBorrowersController < ApplicationController
    def index
      @borrowers = Member.with_loans.paginate(page: params[:page], per_page: 35)
    end
    def show
      if Member.find_by_id(params[:id]).present?
        @borrower = Member.find(params[:id])
      elsif User.find_by_id(params[:id]).present?
        @borrower = User.find(params[:id])
      end
    end
  end
end
