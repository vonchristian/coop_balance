module ManagementModule
  class MembersController < ApplicationController
    def index
      @members = Member.all.order(:last_name)
    end
    def show
      @member = Member.find(params[:id])
    end
  end
end
