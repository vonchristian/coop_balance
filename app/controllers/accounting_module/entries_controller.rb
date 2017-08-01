module AccountingModule
  class EntriesController < ApplicationController
    def index
      @entries = AccountingModule::Entry.all
      @withdrawals =AccountingModule::Entry.withdrawal
      @deposits =AccountingModule::Entry.deposit
      @disbursements =AccountingModule::Entry.loan_disbursement
    end
  end
end
