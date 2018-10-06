module Members
  class BeneficiariesController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @beneficiary = @member.beneficiaries.build
    end
    def create
      @member = Member.find(params[:member_id])
      @beneficiary = @member.beneficiaries.create(beneficiary_params)
      if @beneficiary.valid?
        @beneficiary.save
        redirect_to member_url(@member), notice: "Beneficiary added successfully."
      else
        render :new
      end
    end

    private
    def beneficiary_params
      params.require(:beneficiary).
      permit(:full_name, :relationship)
    end
  end
end 
