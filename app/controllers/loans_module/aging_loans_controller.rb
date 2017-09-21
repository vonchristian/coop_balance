module LoansModule 
  class AgingLoansController < ApplicationController
    def index
      if params[:start_num].present? && params[:end_num].present?
        @start_num = params[:start_num].to_i
        @end_num = params[:end_num].to_i
        @loans = Kaminari.paginate_array(LoansModule::Loan.aging_for(@start_num, @end_num)).page(params[:page]).per(30)
      else
        @loans = Kaminari.paginate_array(LoansModule::Loan.aging).page(params[:page]).per(30)
      end
      respond_to do |format|
        format.html
        format.pdf do 
          pdf = LoansModule::AgingLoansPdf.new(@loans, @start_num, @end_num, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Aging Loans.pdf"
        end
      end
    end 
    def show
    end
  end 
end