module ManagementModule 
	class ShareCapitalsController < ApplicationController
		def index 
			if params[:search].present?
			  @share_capitals = ShareCapital.includes([:member, :share_capital_product]).text_search(params[:search])
		  else 
			  @share_capitals = ShareCapital.includes([:member, :share_capital_product]).all 
			end
		end 
		def show 
			@share_capital = ShareCapital.find(params[:id])
		end
	end 
end 