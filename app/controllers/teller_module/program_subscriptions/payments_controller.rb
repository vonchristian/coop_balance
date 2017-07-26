module TellerDepartment 
	module ProgramSubscriptions 
		class PaymentsController < ApplicationController
			def new 
				@program_subscription = ProgramSubscription.find(params[:program_subscription_id])
				@payment = ProgramSubscriptionPaymentForm.new 
			end  
			def create 
				@program_subscription = ProgramSubscription.find(params[:program_subscription_id])
				@payment = ProgramSubscriptionPaymentForm.new(payment_params)
				if @payment.valid?
					@payment.save 
					redirect_to teller_department_member_url(@program_subscription.member), notice: "Payment for #{@program_subscription.name} saved successfully."
				else 
					render :new 
				end 
			end 

			private 
			def payment_params
				params.require(:program_subscription_payment_form).permit(:program_subscription_id, :reference_number, :amount, :date, :recorder_id)
			end 
		end 
	end 
end 