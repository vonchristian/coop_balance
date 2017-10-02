class MembersController < ApplicationController
  def index
    if params[:search].present?
      @members = Member.text_search(params[:search]).order(:last_name)
    else 
      @members = Member.all.includes([:addresses]).order(:last_name)
    end
  end
  def new 
    @member = Member.new 
    @member.build_tin
  end
  def create 
    @member = Member.create(member_params)
    if @member.valid?
      @member.save 
      redirect_to @member, notice: "Member saved successfully."
    else 
      render :new 
    end 
  end 

  def show
    @member = Member.find(params[:id])
  end

  private 
  def member_params
    params.require(:member).permit(:first_name, :middle_name, :last_name, :sex, :date_of_birth, :contact_number, :avatar)
  end
end 