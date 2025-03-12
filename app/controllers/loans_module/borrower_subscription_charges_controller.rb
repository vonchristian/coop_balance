module LoansModule
  class BorrowerSubscriptionChargesController < ApplicationController
    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @subscription_charge = MembershipsModule::ProgramSubscription.find(params[:program_subscription_id])
      @loan.loan_charges.create(chargeable: @subscription_charge)
      redirect_to loans_module_loan_application_url(@loan), notice: "Subscription charge added successfully."
    end
  end
end
