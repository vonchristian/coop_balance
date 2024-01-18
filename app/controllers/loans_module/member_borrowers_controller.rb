require 'will_paginate/array'
module LoansModule
  class MemberBorrowersController < ApplicationController
    def index
      @borrowers = current_cooperative.member_memberships.with_loans.paginate(page: params[:page], per_page: 35)
    end

    def show
      @borrower = Borrower.find(params[:id])
    end
  end
end
