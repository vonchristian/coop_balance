module ManagementModule
	module Settings
		class CooperativeProductsController < ApplicationController

			def index
				@cooperative = current_user.cooperative
				@share_capital_products = CoopServicesModule::ShareCapitalProduct.all
      	@time_deposit_products = CoopServicesModule::TimeDepositProduct.all
      	@programs = CoopServicesModule::Program.all
      	@savings_registry = Registries::SavingsAccountRegistry.new
			end
		end
	end
end
