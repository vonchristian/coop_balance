class WithdrawalsController < ApplicationController
  def new
    @saving = Saving.find(params[:saving_id])
    @withdrawal = WithdrawalForm.new
  end
  def create
    @saving = Saving.find(params[:saving_id])
    @withdrawal = WithdrawalForm.new(withdrawal_params)
    if @withdrawal.valid?
      @withdrawal.save
      redirect_to "/", notice: "Success"
    else
      render :new
    end
  end

  private
  def withdrawal_params
    params.require(:withdrawal_form).permit(:amount, :or_number, :date, :saving_id)
  end
end
