module Memberships
  module ProgramSubscriptions
    class PaymentsController < ApplicationController
      def new
        @membership = current_cooperative.memberships.find(params[:membership_id])
        @program_subscription = MembershipsModule::ProgramSubscription.find(params[:program_subscription_id])
        @payment = Memberships::ProgramSubscriptions::PaymentProcessing.new
      end

      def create
        @membership = current_cooperative.memberships.find(params[:membership_id])
        @program_subscription = MembershipsModule::ProgramSubscription.find(params[:program_subscription_id])
        @payment = Memberships::ProgramSubscriptions::PaymentProcessing.new(payment_params)
        if @payment.valid?
          @payment.save
          redirect_to member_subscriptions_url(@membership.cooperator), notice: "Payment saved successfully"
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def payment_params
        params.require(:memberships_program_subscriptions_payment_processing)
              .permit(:program_subscription_id, :recorder_id, :amount, :or_number, :date, :membership_id)
      end
    end
  end
end
