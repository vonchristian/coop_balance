class MembersController < ApplicationController
  def index
    if params[:search].present?
      @members = Member.text_search(params[:search]).order(:last_name).paginate(page: params[:page], per_page: 35)
    else
      @members = Member.all.includes([:addresses]).order(:last_name).paginate(page: params[:page], per_page: 35)
    end
    @membership_applications = Membership.pending
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
    if @member.save
      redirect_to member_info_index_url(@member), notice: "Member updated successfully."
      @member.memberships.each(&:save) #update search terms on memberships table
    else
      render :edit
    end
  end


  private
  def member_params
    params.require(:member).permit(:civil_status, :membership_date, :first_name, :middle_name, :last_name, :sex, :date_of_birth, :contact_number, :avatar, tin_attributes: [:number], membership_attributes: [:membership_type],
      addresses_attributes: [:street, :barangay, :municipality, :province])
  end
end
