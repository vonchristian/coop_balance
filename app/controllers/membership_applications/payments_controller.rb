module MembershipApplications
  class PaymentsController < ApplicationController
    def new
      @membership = Membership.find(params[:membership_application_id])
      @entry = MembershipApplications::PaymentProcessing.new
    end
    def create
      @membership = Membership.find(params[:membership_application_id])
      @entry = MembershipApplications::PaymentProcessing.new(payment_params)
      if @entry.valid?
        @entry.save
        redirect_to membership_url(@membership), notice: "Payment saved successfully"
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:membership_applications_payment_processing).permit(:date, :reference_number, :description, :membership_id, :recorder_id)
    end
  end
end
