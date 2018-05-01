require 'will_paginate/array'
module LoansModule
  class AgingLoansController < ApplicationController
    def index
      if params[:start_num].present? && params[:end_num].present?
        @start_num = params[:start_num].to_i
        @end_num = params[:end_num].to_i
        @loans = LoansModule::Loan.aging(start_num: @start_num, end_num: @end_num).paginate(page: params[:page],per_page:30)
      else
        @loans = LoansModule::Loan.aging.paginate(page: params[:page],per_page:30)
      end
      respond_to do |format|
        format.html
        format.pdf do
          pdf = LoansModule::Reports::AgingLoansPdf.new(@loans, @start_num, @end_num, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Aging Loans.pdf"
        end
      end
    end
    def show
    end
  end
end
