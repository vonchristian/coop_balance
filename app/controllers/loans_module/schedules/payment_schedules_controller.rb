module LoansModule
  module Schedules
    class PaymentSchedulesController < ApplicationController
      def new
        @loan_charge = LoansModule::LoanCharge.find(params[:loan_charge_id])
        @payment_schedule = @loan_charge.loan_charge_payment_schedules.build
      end
      def create
        @loan_charge = LoansModule::LoanCharge.find(params[:loan_charge_id])
        @payment_schedule = @loan_charge.loan_charge_payment_schedules.create(payment_schedule_params)
        if @payment_schedule.save
          redirect_to new_loans_module_loan_charge_payment_schedule_path(@loan_charge), notice: "Schedule created successfully"
        else
          render :new
        end
      end

      private
      def payment_schedule_params
        params.require(:loan_charge_payment_schedule).permit(:date, :amount, :loan_charge_id)
      end
    end
  end
end
