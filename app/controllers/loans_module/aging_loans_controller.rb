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
    end 
    def show
    end
  end 
end