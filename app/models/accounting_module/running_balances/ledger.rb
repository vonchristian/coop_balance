# frozen_string_literal: true

module AccountingModule
  module RunningBalances
    class Ledger < ApplicationRecord
      self.table_name = 'ledger_running_balances'

      monetize :amount_cents, as: :amount, numericality: true

      belongs_to :entry, class_name: 'AccountingModule::Entry'
      belongs_to :ledger, class_name: 'AccountingModule::Ledger'

      validates :entry_date, :entry_time, presence: true

      validates :entry_id, uniqueness: { scope: :ledger_id }

      def self.balance(entry_date: nil)
        running_balance = where(entry_date: entry_date).order(entry_time: :desc).last
        return Money.new(running_balance.amount).amount if running_balance.present?

        Money.new(latest.amount).amount
      end

      def self.latest
        order(entry_date: :desc, entry_time: :desc).first
      end
    end
  end
end
