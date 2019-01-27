class MembersController < ApplicationController
  layout 'application'

  respond_to :html, :json

  def index
    if params[:search].present?
      @members = current_cooperative.member_memberships.with_attached_avatar.includes(:memberships).text_search(params[:search]).order(:last_name).paginate(page: params[:page], per_page: 35)
    else
      @members = current_cooperative.member_memberships.with_attached_avatar.order(:last_name).paginate(page: params[:page], per_page: 35)
    end
  end

  def show
    @member = Member.find(params[:id])
    @address =@member.current_address
  end

  def edit
    @member = current_cooperative.member_memberships.find(params[:id])
    respond_modal_with @member
  end

  def update
    @member = current_cooperative.member_memberships.find(params[:id])
    @member.update(member_params)
    respond_modal_with @member, location: member_url(@member), notice: "Member updated successfully."
  end

  def destroy
    @member = current_cooperative.member_memberships.find(params[:id])
    if @member.savings.present? &&
       @member.time_deposits.present? &&
       @member.share_capitals.present? &&
       @member.loans.present?
       redirect_to member_url(@member), alert: "Savings, share capitals, time deposits and loans are still present."
     else
      @member.destroy
      redirect_to members_url, notice: "Member account deleted successfully."
    end
  end

  private
  def member_params
    params.require(:member).permit(
      :civil_status, :membership_date,
      :first_name, :middle_name, :last_name,
      :sex, :date_of_birth, :avatar,
      :signature_specimen,
      tin_attributes: [:number])
  end
end
