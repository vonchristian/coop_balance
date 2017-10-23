module Loans
	class RealPropertiesController < ApplicationController 
		def index 
		end 
		def new
      @loan = LoansModule::Loan.find(params[:loan_id]) 
			@real_property = RealProperty.new
      @real_property.pictures.build
		end 
    def create 
      @loan = LoansModule::Loan.find(params[:loan_id]) 
      @real_property = RealProperty.create(property_params)
      if @real_property.valid?
        @real_property.save    
        if params[:images]
          params[:images].each { |image|
          @real_property.pictures.create(image: image)
          }
        end
        redirect_to new_loan_collateral_url(@loan), notice: "Real Property added successfully."
      else 
        render :new 
      end 
    end 
    def show 
      @real_property = RealProperty.find(params[:id])
    end

    private 
    def property_params
      params.require(:real_property).permit(:description, :owner_id, :owner_type, :images)
    end
	end 
end 