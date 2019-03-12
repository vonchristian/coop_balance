module Barangays
	class SettingsController < ApplicationController

		def index
			@barangay = current_cooperative.barangays.find(params[:barangay_id])
		end
	end
end