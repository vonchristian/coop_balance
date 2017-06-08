module AccountingDepartment
  class EntriesController < ApplicationController
    def index
      @entries = AccountingDepartment::Entry.all
      @withdrawals =AccountingDepartment::Entry.withdrawal
      @deposits =AccountingDepartment::Entry.deposit
      @disbursements =AccountingDepartment::Entry.disbursement
    end
  end
end
