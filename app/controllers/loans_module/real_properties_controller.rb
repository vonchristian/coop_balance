module LoansModule 
	class RealPropertiesController < ApplicationController 
		def index 
		end 
		def new 
			@member = Member.find(params[:member_id])
			@real_property = @member.real_properties.build 
		end 
	end 
end 