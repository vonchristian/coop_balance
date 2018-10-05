module ManagementModule
	module Settings
		class CooperativeProductsController < ApplicationController

			def index
				@cooperative = current_user.cooperative
				@share_capital_products = CoopServicesModule::ShareCapitalProduct.all
      	@time_deposit_products = CoopServicesModule::TimeDepositProduct.all
      	@loan_products = LoansModule::LoanProduct.all
      	@saving_products = CoopServicesModule::SavingProduct.all
			end
		end
	end
end
