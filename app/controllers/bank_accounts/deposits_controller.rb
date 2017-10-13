module BankAccounts 
  class DepositsController < ApplicationController 
    def new 
      @bank_account = BankAccount.find(params[:bank_account_id])
      @entry = BankAccounts::EntryForm.new 
    end 
    def create
      @bank_account = BankAccount.find(params[:bank_account_id])
      @entry = BankAccounts::EntryForm.new(entry_params)
      if @entry.valid?
        @entry.save 
        redirect_to bank_account_url(@bank_account), notice: "Entry saved successfully."
      else 
        render :new 
      end 
    end 

    private 
    def entry_params 
      params.require(:bank_accounts_entry_form).permit(:amount, :or_number, :date, :bank_account_id, :entry_type, :description, :recorder_id, :debit_account_id, :credit_account_id)
    end 
  end 
end 