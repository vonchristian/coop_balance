class LeadsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  def create
    @lead = Lead.create(lead_params)
    @lead.save!
    redirect_to "/home", notice: "Thank you. Please open your email for schedule of demo."
  end

  private
  def lead_params
    params.require(:lead).permit(:email, :contact_number)
  end
end
