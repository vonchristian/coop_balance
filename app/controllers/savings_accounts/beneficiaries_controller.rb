module SavingsAccounts
	class BeneficiariesController < ApplicationController
		respond_to :html, :json
		
		def edit
			@saving = current_cooperative.savings.find(params[:id])
			respond_modal_with @saving
		end

		def update
			@saving = current_cooperative.savings.find(params[:id])
			@saving.update(saving_params)
			respond_modal_with @saving, 
				location: savings_account_url(@saving)
		end

		private
		def saving_params
			params.require(:memberships_module_saving).permit(:beneficiaries)
		end
	end
end