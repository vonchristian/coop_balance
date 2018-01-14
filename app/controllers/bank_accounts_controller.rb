class BankAccountsController < ApplicationController
  def index
    @bank_accounts = BankAccount.all
  end
  def new
    @bank_account = BankAccount.new
  end
  def create
    @bank_account = BankAccount.create(bank_account_params)
    if @bank_account.valid?
      @bank_account.save
      redirect_to bank_account_url(@bank_account), notice: "Bank account details saved successfully"
    else
      render :new
    end
  end
  def show
    @bank_account = BankAccount.find(params[:id])
    @entries = @bank_account.entries.order(entry_date: :desc).paginate(page: params[:page], per_page: 35)
  end

  private
  def bank_account_params
    params.require(:bank_account).permit(:bank_name, :bank_address, :account_number, :account_id)
  end
end
