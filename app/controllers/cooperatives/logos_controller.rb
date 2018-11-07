module Cooperatives
	class LogosController < ApplicationController

		def create
			@cooperative = current_cooperative
			@logo = @cooperative.update(logo_params)
			redirect_to management_module_settings_path, notice: 'Logo updated.'
		end

		private
			def logo_params
				params.require(:cooperative).permit(:logo)
			end
	end
end
