module LoansModule 
	class SettingsController < ApplicationController
		def index 
			@charges = Charge.all
		end 
	end 
end 