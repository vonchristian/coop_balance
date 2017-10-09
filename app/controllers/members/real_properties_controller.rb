module Members
  class RealPropertiesController < ApplicationController 
    def index 
    end 
    def new 
      @member = Member.friendly.find(params[:member_id])
      @real_property = @member.real_properties.build 
    end 
    def create 
      @member = Member.friendly.find(params[:member_id])
      @real_property = @member.real_properties.create(real_property_params)
      if @real_property.save 
        redirect_to member_info_index_url, notice: "Property saved successfully."
      else 
        render :new 
      end 
    end 

    private 
    def real_property_params
      params.require(:real_property).permit(:address)
    end
  end 
end 