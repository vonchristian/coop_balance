module TimeDeposits
  class FixedTermsController < ApplicationController
    def new
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @fixed_term = @time_deposit.fixed_terms.build
    end

    def create
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @fixed_term = @time_deposit.fixed_terms.create(fixed_term_params)
      if @fixed_term.save
        redirect_to time_deposit_url(@time_deposit), notice: "Term saved successfully"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def fixed_term_params
      params.require(:time_deposits_module_fixed_term).permit(:deposit_date, :number_of_days, :maturity_date)
    end
  end
end
