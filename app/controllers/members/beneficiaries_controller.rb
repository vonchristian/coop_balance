module Members
  class BeneficiariesController < ApplicationController
    respond_to :html, :json

    def new
      @member = Member.find(params[:member_id])
      @beneficiary = @member.beneficiaries.build
      respond_modal_with @beneficiary
    end

    def create
      @member = Member.find(params[:member_id])
      @beneficiary = @member.beneficiaries.create(beneficiary_params)
      respond_modal_with @beneficiary, location: member_url(@member), notice: "Beneficiary added successfully."
    end

    def destroy
      @member = Member.find(params[:member_id])
      @beneficiary = Beneficiary.find(params[:id])
      @beneficiary.destroy
      redirect_to member_url(@member), notice: "Beneficiary deleted successfully."
    end

    private
    def beneficiary_params
      params.require(:beneficiary).
      permit(:full_name, :relationship)
    end
  end
end
