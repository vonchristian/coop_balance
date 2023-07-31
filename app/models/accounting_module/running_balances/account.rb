# frozen_string_literal: true

module AccountingModule
  module RunningBalances 
    class Account < ApplicationRecord
      self.table_name = 'account_running_balances'

      monetize :amount_cents, as: :amount, numericality: true

      belongs_to :entry, class_name: 'AccountingModule::Entry'
      belongs_to :account, class_name: 'AccountingModule::Account'

      validates :entry_date, :entry_time, presence: true 

      validates :entry_id, uniqueness: { scope: :account_id }

      def self.balance(entry_date: nil)
        running_balance = where(entry_date: entry_date).order(entry_time: :desc).last
        return 0 if running_balance.blank? 

        Money.new(running_balance.amount).amount
      end

      def self.latest 
        order(entry_date: :desc, entry_time: :desc).first 
      end

    end
  end 
end 
