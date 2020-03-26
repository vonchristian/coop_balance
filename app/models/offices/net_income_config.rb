module Offices 
  class NetIncomeConfig < ApplicationRecord
    enum book_closing: [:annually, :semi_annually, :quarterly, :monthly]
   
    belongs_to :office,                      class_name: 'Cooperatives::Office'
    belongs_to :net_surplus_account,         class_name: 'AccountingModule::Account'
    belongs_to :net_loss_account,            class_name: 'AccountingModule::Account'
    belongs_to :total_revenue_account,       class_name: 'AccountingModule::Account'
    belongs_to :total_expense_account,       class_name: 'AccountingModule::Account'
    belongs_to :interest_on_capital_account, class_name: "AccountingModule::Account"
    has_many :accountable_accounts,          class_name: "AccountingModule::AccountableAccount", as: :accountable 
    has_many :accounts,                      through: :accountable_accounts, class_name: "AccountingModule::Account"
    has_many :entries,                       through: :accounts, class_name: "AccountingModule::Entry"
   
    validates :net_surplus_account_id, :net_loss_account_id, :total_revenue_account_id, :total_expense_account_id, uniqueness: { scope: :office_id }
    
    def self.current 
      order(created_at: :desc).first 
    end 

    def books_closed?(from_date:, to_date:)
      parsed_from_date = beginning_date(from_date)
      parsed_to_date   = ending_date(to_date)
      entries.entered_on(from_date: parsed_from_date, to_date: parsed_to_date).present?
    end 

    def date_setter
      "NetIncomeConfigs::DateSetters::#{book_closing.titleize.gsub(' ', "")}".constantize
    end 

    def beginning_date(date)
      date_setter.new(net_income_config: self, date: date).beginning_date
    end 

    def ending_date(date)
      date_setter.new(net_income_config: self, date: date).ending_date
    end 

    def total_revenues(args={})
      from_date = args[:from_date] ? args[:from_date] : Date.current.beginning_of_year
      to_date   = args[:to_date]   ? args[:to_date]   : Date.current.end_of_year
      
      if books_closed?(from_date: from_date, to_date: to_date)
        total_revenue_account.debits_balance(from_date: from_date, to_date: to_date)
      else 
        office.level_one_account_categories.revenues.balance(from_date: from_date, to_date: to_date)
      end 
    end
    
    def total_expenses(args={})
      from_date = args[:from_date] ? args[:from_date] : Date.current.beginning_of_year
      to_date   = args[:to_date]   ? args[:to_date]   : Date.current.end_of_year
      if books_closed?(from_date: from_date, to_date: to_date)
        total_expense_account.credits_balance(from_date: from_date, to_date: to_date)
      else 
        office.level_one_account_categories.expenses.credits_balance(from_date: from_date, to_date: to_date)
      end 
    end

    def total_net_surplus(args={})
      from_date = args[:from_date] ? args[:from_date] : Date.current.beginning_of_year
      to_date   = args[:to_date]   ? args[:to_date]   : Date.current.end_of_year

      if books_closed?(from_date: from_date, to_date: to_date)
        net_surplus_account.credits_balance(from_date: from_date, to_date: to_date)
      else 
        office.level_one_account_categories.revenues.balance(from_date: from_date, to_date: to_date) - office.level_one_account_categories.expenses.balance(from_date: from_date, to_date: to_date)
      end 
    end

    def total_net_loss(args={})
      from_date = args[:from_date] ? args[:from_date] : Date.current.beginning_of_year
      to_date   = args[:to_date] ? args[:to_date] : Date.current.end_of_year

      if books_closed?(from_date: from_date, to_date: to_date)
        net_loss_account.debits_balance(from_date: from_date, to_date: to_date)
      else 
        office.level_one_account_categories.expenses.balance(from_date: from_date, to_date: to_date) - office.level_one_account_categories.revenues.balance(from_date: from_date, to_date: to_date)
      end 
    end
  end
end 