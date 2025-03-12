module Employees
  class CashTransfersController < ApplicationController
    def new
      @employee = current_user
      @cash_transfer = Employees::CashTransferProcessing.new
    end

    def create
      @employee = current_user
      @cash_transfer = Employees::CashTransferProcessing.new(cash_transfer_params)
      if @cash_transfer.valid?
        @cash_transfer.save
        redirect_to employee_url(@employee), notice: "Cash transferred successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def cash_transfer_params
      params.require(:employees_cash_transfer_processing)
            .permit(
              :amount,
              :reference_number,
              :date,
              :description,
              :transferred_to_id,
              :employee_id
            )
    end
  end
end
