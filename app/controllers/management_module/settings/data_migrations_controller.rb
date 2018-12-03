module ManagementModule
	module Settings
		class DataMigrationsController < ApplicationController
			def index
      	@savings_registry = Registries::SavingsAccountRegistry.new
      	@share_capital_registry = Registries::ShareCapitalRegistry.new
      	@loan_registry = Registries::LoanRegistry.new
      	@time_deposit_registry = Registries::TimeDepositRegistry.new
      	@member_registry = Registries::MemberRegistry.new
			end
		end
	end
end
