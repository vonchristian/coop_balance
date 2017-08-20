module ManagementModule
  class EntriesController < ApplicationController
    def index
      @entries = AccountingModule::Entry.includes([:recorder, :debit_amounts, commercial_document: :member]).all
      @withdrawals =AccountingModule::Entry.withdrawal.includes([:commercial_document,:recorder, :debit_amounts]).all
      @deposits =AccountingModule::Entry.deposit.includes([:commercial_document, :recorder, :debit_amounts]).all
      @disbursements =AccountingModule::Entry.loan_disbursement.includes([:commercial_document, :recorder, :debit_amounts]).all
    end
  end
end