module AccountingModule
  module ScheduledEntries
    class SavingsAccountsInterestPostingsController < ApplicationController
      def new
        @interest_expense_posting = AccountingModule::Entries::SavingsInterestExpenseEntry.new
        @savings_accounts = current_cooperative.savings.has_minimum_balances.paginate(page: params[:page], per_page: 2)
        @to_date          = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
      end
      def create
        @interest_expense_posting = AccountingModule::Entries::SavingsInterestExpenseEntry.new(voucher_params)
        @interest_expense_posting.process!
        redirect_to accounting_module_interest_expense_voucher_url(@interest_expense_posting.find_voucher), url: "Voucher created succesfully."
      end

      private
      def voucher_params
        params.require(:accounting_module_entries_savings_interest_expense_entry).
        permit(:date, :cooperative_id, :account_number, :employee_id, :reference_number, :description)
      end
    end
  end
end
