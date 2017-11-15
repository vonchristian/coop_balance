module MembershipApplications
  class PaymentsController < ApplicationController
    def new
      @member = Member.find(params[:membership_application_id])
      @entry = MembershipApplications::PaymentForm.new
    end
    def create
      @member = Member.find(params[:membership_application_id])
      @entry = MembershipApplications::PaymentForm.new(payment_params)
      if @entry.valid?
        @entry.save
        redirect_to member_url(@member), notice: "Payment saved successfully"
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:membership_applications_payment_form).permit(:date, :reference_number, :description, :member_id, :recorder_id)
    end
  end
end
