# frozen_string_literal: true

module AccountingModule
  module RunningBalances
    class CreateService < ActiveInteraction::Base
      object :entry, class: 'AccountingModule::Entry'

      def execute
        entry.accounts.includes(:ledger, :amounts).find_each do |account|
          create_account_running_balance(account)
          create_ledger_running_balance(account.ledger)
        end
      end

      private

      def create_account_running_balance(account)
        account.running_balances.first_or_create(
          entry: entry,
          entry_date: entry.entry_date,
          entry_time: entry.entry_time,
          amount: account.balance(to_date: entry.entry_date, to_time: entry.entry_time)
        )
      end

      def create_ledger_running_balance(ledger)
        return if ledger.blank?

        ledger.running_balances.first_or_create(
          entry: entry,
          entry_date: entry.entry_date,
          entry_time: entry.entry_time,
          amount: ledger.balance(to_date: entry.entry_date, to_time: entry.entry_time)
        )
      end
    end
  end
end
