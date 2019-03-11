module Employees
  class CashCountLineItemsController < ApplicationController
    def new
      @employee = User.find(params[:employee_id])
      @cash_count = CashCount.new
      @bills = Bill.all
    end
    def create
      @bills = Bill.all
      @cash_count = CashCount.create(cash_count_params)
      if @cash_count.valid?
        @cash_count.save!
        redirect_to new_employee_cash_count_line_item_url(current_user), notice: 'added successfully.'
      else
        render :new
      end
    end

    private
    def cash_count_params
      params.require(:cash_count).permit(:bill_id, :quantity, :cart_id)
    end
  end
end
