require 'will_paginate/array'
module Barangays
  class MembersController < ApplicationController
    def index
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @members = @barangay.members
    end

    def new
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @member = Barangays::MembershipProcessing.new(barangay_id: @barangay.id)
      if params[:search].present?
        @members = @barangay.members.text_search(params[:search]).order(:last_name).uniq.paginate(page: params[:page], per_page: 35)
      else
        @members = @barangay.members.uniq.paginate(page: params[:page], per_page: 25)
      end
    end

    def create
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @member = Barangays::MembershipProcessing.new(
        member_params.merge(
          barangay_id: @barangay.id,
          cooperative_id: current_cooperative.id
        )
      )
      @member.process!
      redirect_to new_barangay_member_url(@barangay), notice: "Member added successfully."
    end

    private
    def member_params
      params.require(:barangays_membership_processing).permit(:barangay_membership_id, :barangay_membership_type)
    end
  end
end
