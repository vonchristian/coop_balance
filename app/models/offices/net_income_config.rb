module Offices
  class NetIncomeConfig < ApplicationRecord
    enum :book_closing, { annually: 0, semi_annually: 1, quarterly: 2, monthly: 3 }

    belongs_to :office,                      class_name: "Cooperatives::Office"
    belongs_to :net_surplus_account,         class_name: "AccountingModule::Account"
    belongs_to :net_loss_account,            class_name: "AccountingModule::Account"
    belongs_to :total_revenue_account,       class_name: "AccountingModule::Account"
    belongs_to :total_expense_account,       class_name: "AccountingModule::Account"
    belongs_to :interest_on_capital_account, class_name: "AccountingModule::Account"
    has_many :entries,                       through: :accounts, class_name: "AccountingModule::Entry"

    validates :net_surplus_account_id, :net_loss_account_id, :total_revenue_account_id, :total_expense_account_id, :interest_on_capital_account_id, uniqueness: { scope: :office_id }

    def self.current
      order(created_at: :desc).first
    end

    def accounts
      account_ids = []
      account_ids << net_surplus_account_id
      account_ids << net_loss_account_id
      account_ids << total_revenue_account_id
      account_ids << total_expense_account_id
      account_ids << interest_on_capital_account_id

      AccountingModule::Account.where(id: account_ids)
    end

    def books_closed?(from_date:, to_date:)
      parsed_from_date = beginning_date(from_date)
      parsed_to_date   = ending_date(to_date)
      entries.entered_on(from_date: parsed_from_date, to_date: parsed_to_date).present?
    end

    def date_setter
      "NetIncomeConfigs::DateSetters::#{book_closing.titleize.delete(' ')}".constantize
    end

    def beginning_date(date)
      date_setter.new(net_income_config: self, date: date).beginning_date
    end

    def ending_date(date)
      date_setter.new(net_income_config: self, date: date).ending_date
    end

    def total_revenues(args = {})
      from_date = args[:from_date] || Date.current.beginning_of_year
      to_date   = args[:to_date]   || Date.current.end_of_year

      if books_closed?(from_date: from_date, to_date: to_date)
        total_revenue_account.debits_balance(from_date: from_date, to_date: to_date)
      else
        office.ledgers.revenue.balance(from_date: from_date, to_date: to_date)
      end
    end

    def total_expenses(args = {})
      from_date = args[:from_date] || Date.current.beginning_of_year
      to_date   = args[:to_date]   || Date.current.end_of_year
      if books_closed?(from_date: from_date, to_date: to_date)
        total_expense_account.credits_balance(from_date: from_date, to_date: to_date)
      else
        office.ledgers.expense.credits_balance(from_date: from_date, to_date: to_date)
      end
    end

    def total_net_surplus(args = {})
      from_date = args[:from_date] || Date.current.beginning_of_year
      to_date   = args[:to_date]   || Date.current.end_of_year

      if books_closed?(from_date: from_date, to_date: to_date)
        net_surplus_account.credits_balance(from_date: from_date, to_date: to_date)
      else
        office.ledgers.revenue.balance(from_date: from_date, to_date: to_date) - office.ledgers.expense.balance(from_date: from_date, to_date: to_date)
      end
    end

    def total_net_loss(args = {})
      from_date = args[:from_date] || Date.current.beginning_of_year
      to_date   = args[:to_date] || Date.current.end_of_year

      if books_closed?(from_date: from_date, to_date: to_date)
        net_loss_account.debits_balance(from_date: from_date, to_date: to_date)
      else
        office.ledgers.expense.balance(from_date: from_date, to_date: to_date) - office.ledgers.revenue.balance(from_date: from_date, to_date: to_date)
      end
    end
  end
end
