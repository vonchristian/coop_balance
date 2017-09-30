module ManagementModule
  class MembersController < ApplicationController
    def index
      if params[:search].present?
        @members = Member.text_search(params[:search]).order(:last_name)
      else 
        @members = Member.all.order(:last_name)
      end
    end
    def show
      @member = Member.find(params[:id])
    end
    def import 
      Member.import(params[:file])
      redirect_to management_module_members_url, notice: "Members imported!"
    end
  end
end
