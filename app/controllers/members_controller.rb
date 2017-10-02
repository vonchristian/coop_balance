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
    @member.addresses.build
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
  def edit 
    @member = Member.find(params[:id])
  end 
  def update 
    @member = Member.find(params[:id])
    @member.update(member_params)
    if @member.save 
      redirect_to @member, notice: "Member updated successfully."
    else 
      render :edit 
    end 
  end 


  private 
  def member_params
    params.require(:member).permit(:first_name, :middle_name, :last_name, :sex, :date_of_birth, :contact_number, :avatar, tin_attributes: [:number],
      addresses_attributes: [:street, :barangay, :municipality, :province])
  end
end 