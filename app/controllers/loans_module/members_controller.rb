module LoansModule
  class MembersController < ApplicationController
    def index
      if params[:search].present?
        @members = Member.text_search(params[:search]).page(params[:papge]).per(35)
      else
        @members = Member.all.order(:last_name).page(params[:page]).per(35)
      end
    end
    def show
      @member = Member.find(params[:id])
    end
  end
end
