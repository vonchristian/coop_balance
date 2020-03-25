class MembersController < ApplicationController
  layout 'application'



  def index
    if params[:search].present?
      @pagy, @members = pagy(Member.for_cooperative(cooperative: current_cooperative).with_attached_avatar.includes(:memberships).text_search(params[:search]).order(:last_name))
    else
      @pagy, @members = pagy(Member.for_cooperative(cooperative: current_cooperative).with_attached_avatar.includes(:memberships).with_attached_avatar.order(:last_name))
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
