module LoansModule
  class CollateralsController < ApplicationController
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @collateral = @loan.collaterals.build
    end

    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @collateral = @loan.collaterals.create(collateral_params)
      if @collateral.valid?
        @collateral.save
        redirect_to new_loan_collateral_url(@loan), notice: 'Collateral added successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def collateral_params
      params.require(:loans_module_collateral).permit(:real_property_id)
    end
  end
end
