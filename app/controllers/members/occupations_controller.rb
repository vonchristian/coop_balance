module Members
  class OccupationsController < ApplicationController
    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @occupation = @member.occupations.build
    end
    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @occupation = @member.occupations.create(occupation_params)
      if @occupation.valid?
        @occupation.save
        redirect_to member_url(@member), notice: "Occupation added successfully."
      else
        render :new
      end
    end

    private
    def occupation_params
      params.require(:occupation).permit(:title)
    end
  end
end
