module ManagementDepartment
  class EntriesController < ApplicationController
    def index
      @entries = AccountingDepartment::Entry.includes([:recorder, :debit_amounts, commercial_document: :member]).all
      @withdrawals =AccountingDepartment::Entry.withdrawal.includes([:commercial_document,:recorder, :debit_amounts]).all
      @deposits =AccountingDepartment::Entry.deposit.includes([:commercial_document, :recorder, :debit_amounts]).all
      @disbursements =AccountingDepartment::Entry.disbursement.includes([:commercial_document, :recorder, :debit_amounts]).all
    end
  end
end