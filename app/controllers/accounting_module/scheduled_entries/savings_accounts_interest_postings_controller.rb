module AccountingModule
  module ScheduledEntries
    class SavingsAccountsInterestPostingsController < ApplicationController
      def new
        @interest_expense_posting = AccountingModule::Entries::SavingsInterestExpenseEntry.new
        @pagy, @savings_accounts  = pagy(current_office.savings, items: 5)
        @to_date                  = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.current
      end

      def create
        @interest_expense_posting = AccountingModule::Entries::SavingsInterestExpenseEntry.new(voucher_params)
        @interest_expense_posting.process!

        redirect_to accounting_module_interest_expense_voucher_url(id: @interest_expense_posting.find_voucher.id), url: "Voucher created succesfully."
      end

      private

      def voucher_params
        params.require(:accounting_module_entries_savings_interest_expense_entry)
              .permit(:date, :cooperative_id, :account_number, :employee_id, :reference_number, :description)
      end
    end
  end
end
