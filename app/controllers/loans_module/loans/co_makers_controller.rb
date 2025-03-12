require "will_paginate/array"
module LoansModule
  module Loans
    class CoMakersController < ApplicationController
      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @co_maker = @loan.loan_co_makers.build
        @co_makers = current_cooperative.member_memberships.with_attached_avatar.paginate(page: params[:page], per_page: 25)
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @co_maker = @loan.loan_co_makers.create(co_maker_params)
        @co_maker.save
        redirect_to new_loans_module_loan_co_maker_url(@loan), notice: "Added successfully"
      end

      private

      def co_maker_params
        params.require(:loans_module_loan_co_maker)
              .permit(:co_maker_id, :co_maker_type)
      end
    end
  end
end
