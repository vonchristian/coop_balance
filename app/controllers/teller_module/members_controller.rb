module TellerDepartment 
	class MembersController < ApplicationController 
		def index 
			if params[:search].present?
				@members = Member.text_search(params[:search])
			else 
				@members = Member.all 
			end 
		end 
		def show 
			@member = Member.find(params[:id])
		end 
		def new 
			@member = Member.new 
		end 
		def create
			@member = Member.new(member_registration_params)
			if @member.valid?
				@member.save 
				redirect_to teller_department_member_url(@member), notice: "Member saved successfully"
			else 
				render @member 
			end 
		end
		private 
		def member_registration_params
			params.require(:member).permit(:first_name, :middle_name, :last_name, :sex, :date_of_birth, :avatar)
		end 
	end 
end 