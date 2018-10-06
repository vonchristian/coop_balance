class MembersController < ApplicationController
  layout 'application'

  def index
    if params[:search].present?
      @members = current_cooperative.member_memberships.text_search(params[:search]).order(:last_name).paginate(page: params[:page], per_page: 35)
    else
      @members = current_cooperative.member_memberships.order(:last_name).paginate(page: params[:page], per_page: 35)
    end
  end

  def show
    @member = Member.find(params[:id])
  end
  def edit
    @member = Member.find(params[:id])
  end
  def update
    @member = Member.find(params[:id])
    @member.update(member_params)
    if @member.valid?
      @member.save
      redirect_to member_settings_url(@member), notice: "Member updated successfully."

      # @member.memberships.each(&:save) #update search terms on memberships table
    else
      render :edit
    end
  end

  def destroy
    @member = Member.find(params[:id])
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
    params.require(:member).permit(:civil_status, :membership_date, :first_name, :middle_name, :last_name, :sex, :date_of_birth, :contact_number, :avatar, :signature_specimen, tin_attributes: [:number])
  end
end
