module AccountingModule
  module ScheduledEntries
    class SavingsAccountsInterestPostingsController < ApplicationController
      def new
        @journal_entry_voucher = AccountingModule::SavingsInterestPostingVoucher.new
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
        @cooperative = current_cooperative
        @savings_accounts = current_cooperative.savings
      end
      def create
        @journal_entry_voucher = AccountingModule::SavingsInterestPostingVoucher.new(voucher_params)
        @journal_entry_voucher.process!
        redirect_to voucher_url(@journal_entry_voucher.find_voucher), url: "Voucher created succesfully."
      end

      private
      def voucher_params
        params.require(:accounting_module_savings_interest_posting_voucher).
        permit(:to_date, :cooperative_id, :account_number, :employee_id)
      end
    end
  end
end
