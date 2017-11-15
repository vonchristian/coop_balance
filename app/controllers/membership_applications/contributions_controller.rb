module MembershipApplications
  class ContributionsController < ApplicationController
    def new
      @membership = Membership.find(params[:membership_application_id])
    end
  end
end
