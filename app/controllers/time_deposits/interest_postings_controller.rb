module TimeDeposits
  class InterestPostingsController < ApplicationController
    def new
      @time_deposit     = current_office.time_deposits.find(params[:time_deposit_id])
      @interest_posting = TimeDeposits::InterestPosting.new
    end

    def create
      @time_deposit     = current_office.time_deposits.find(params[:time_deposit_id])
      @interest_posting = TimeDeposits::InterestPosting.new(interest_posting_params)
      if @interest_posting.valid?
        @interest_posting.process!
        redirect_to time_deposit_interest_posting_url(id: @interest_posting.find_voucher.id), notice: "Voucher created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
      @voucher      = current_office.vouchers.find(params[:id])
    end

    private

    def interest_posting_params
      params.require(:time_deposits_interest_posting)
            .permit(:date, :reference_number, :description, :amount, :employee_id, :time_deposit_id, :account_number)
    end
  end
end
