module Members
  class SignatureSpecimensController < ApplicationController
    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @signature_specimen = @member.update(signature_specimen_params)
      redirect_to member_info_index_path(@member), notice: "Signature Specimen updated."
    end

    private

    def signature_specimen_params
      params.require(:member).permit(:signature_specimen)
    end
  end
end
