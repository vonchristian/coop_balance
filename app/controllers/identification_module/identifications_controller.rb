module IdentificationModule
  class IdentificationsController < ApplicationController
    def index
      @identifications = IdentificationModule::Identification.all
    end
    def new
      @identifiable = params[:identifiable_type].constantize.find(params[:identifiable_id])
      @identification = @identifiable.identifications.build
    end
    def create
      @identifiable = params[:identification_module_identification][:identifiable_type].constantize.find(params[:identification_module_identification][:identifiable_id])
      @identification = @identifiable.identifications.create(identification_params)
      if @identification.valid?
        @identification.save
        redirect_to member_path(@identifiable), notice: 'Identification saved successfully.'
      else
        render :new
      end
    end

    private
    def identification_params
      params.require(:identification_module_identification).
      permit(:identifiable_id, :identifiable_type, :identity_provider_id, :issuance_date, :expiry_date, :number, :photo)
    end
  end
end
