module ManagementModule
	module Settings
		class GeneralsController < ApplicationController

			def index
				@cooperative = current_user.cooperative
			end
		end
	end
end
