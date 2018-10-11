module Organizations
  class ShareCapitalsController < ApplicationController
    def index
      @organization = current_cooperative.organizations.find(params[:organization_id])
      @share_capitals = @organization.member_share_capitals.paginate(page: params[:page], per_page: 25)
    end
  end
end
