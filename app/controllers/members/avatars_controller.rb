module Members
	class AvatarsController < ApplicationController

		def create
			@member = Member.find(params[:member_id])
			@avatar = @member.update!(avatar_params)
			redirect_to member_info_index_path(@member), notice: 'Avatar updated.'
		end

		private
			def avatar_params
				params.require(:member).permit(:avatar)
			end
	end
end