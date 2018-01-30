module StoreFrontModule
	class MembersController < ApplicationController
    def index
      @members = Member.all
    end
    def show
      @member = Member.friendly.find(params[:id])
    end
  end
end
